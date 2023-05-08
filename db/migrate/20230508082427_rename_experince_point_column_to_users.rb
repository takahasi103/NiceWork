class RenameExperincePointColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :experince_point, :experience_point
  end
end
