class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string  :reference, null: false
      t.string  :email, null: false
      t.date    :live_on
      t.string  :disbursement_frequency, null: false
      t.decimal :minimum_monthly_fee, precision: 16, scale: 2, null: false

      t.index :reference, unique: true
      t.index :email, unique: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
