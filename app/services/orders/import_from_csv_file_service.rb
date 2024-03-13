# frozen_string_literal: true

module Orders
  class ImportFromCsvFileService < ApplicationService
    private

    BATCH_SIZE = 5000
    private_constant :BATCH_SIZE

    def initialize(file_path)
      @file_path = file_path
    end

    def call
      CSV
      .foreach(@file_path, col_sep: ';', headers: true)
      .lazy.each_slice(BATCH_SIZE) do |batch|
        import_batch(batch)
      end
    end

    def import_batch(orders_batch)
      merchant_reference_by_ids = Merchant
        .where(reference: orders_batch.pluck('merchant_reference'))
        .map { |merchant| [merchant.reference, merchant.id] }.to_h

      insertable_batch = orders_batch.map do |item|
        item_h = item.to_h

        item_h[:merchant_id] = merchant_reference_by_ids[item['merchant_reference']]
        item_h[:external_reference] = item['id']

        item_h.delete('merchant_reference')
        item_h.delete('id')

        item_h
      end

      Order.insert_all(insertable_batch)
    end
  end
end
