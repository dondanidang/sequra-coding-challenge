# frozen_string_literal: true

module Merchants
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
          insertable_batch = batch.map(&:to_h)
          Merchant.insert_all(insertable_batch)
        end
    end
  end
end
