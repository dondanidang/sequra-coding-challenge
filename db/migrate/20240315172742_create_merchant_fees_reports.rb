class CreateMerchantFeesReports < ActiveRecord::Migration[7.1]
  def change
    create_table :merchant_fees_reports, id: :uuid do |t|
      t.references :merchant, null: false, foreign_key: true, type: :uuid

      t.decimal :collected_fees, precision: 16, scale: 2, null: false
      t.decimal :outstanding_fees, precision: 16, scale: 2, null: false
      t.date :date, null: false

      t.index %w[merchant_id date], unique: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
