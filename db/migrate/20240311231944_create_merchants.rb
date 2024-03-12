class CreateMerchants < ActiveRecord::Migration[7.1]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string  :reference
      t.string  :email
      t.date    :live_on
      t.string  :disbursement_frequency
      t.decimal :minimum_monthly_fee

      t.index :reference, unique: true
      t.index :email, unique: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
