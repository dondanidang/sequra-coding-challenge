class AddReferenceId < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :external_reference_id, :string
    add_index :orders, :external_reference_id, unique: true
  end
end
