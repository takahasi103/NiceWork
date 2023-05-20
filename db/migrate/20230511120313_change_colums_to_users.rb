class ChangeColumsToUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :is_deleted, :boolean
    add_column :users, :introduction, :text
  end
end
