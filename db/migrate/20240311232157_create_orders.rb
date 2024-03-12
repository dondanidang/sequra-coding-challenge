class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.references :merchant, null: false, foreign_key: true, type: :uuid
      t.references :disbursement, foreign_key: true, type: :uuid

      t.decimal :amount, precision: 16, scale: 2, null: false
      t.decimal :fees, precision: 16, scale: 2



      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
