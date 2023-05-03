class CreateLevelSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :level_settings do |t|
      t.integer :level,   null: false
      t.float :thresold,  null: false

      t.timestamps
    end
  end
end
