class CreateDisbursements < ActiveRecord::Migration[7.1]
  def change
    create_table :disbursements, id: :uuid do |t|
      t.references :merchant, null: false, foreign_key: true, type: :uuid

      t.string :reference,  null: false
      t.decimal :orders_amount, precision: 16, scale: 2, null: false
      t.decimal :merchant_paid_amount, precision: 16, scale: 2, null: false
      t.decimal :total_fees, precision: 16, scale: 2, null: false

      t.index :reference, unique: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
