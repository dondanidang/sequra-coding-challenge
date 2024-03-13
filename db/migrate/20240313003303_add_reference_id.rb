class AddReferenceId < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :reference_id, :string, null: false
    add_index :orders, :reference_id, unique: true
  end
end
