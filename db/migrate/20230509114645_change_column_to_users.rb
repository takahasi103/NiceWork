class ChangeColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :is_disclose, :boolean
    add_column :users, :status, :integer, default: 0, null: false
  end
end
