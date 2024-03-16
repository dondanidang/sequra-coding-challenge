class AddDateToDibursements < ActiveRecord::Migration[7.1]
  def change
    add_column :disbursements, :date, :date, null: false
  end
end
