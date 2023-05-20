class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.references :user,      null: false, foreign_key: true
      t.references :post,      null: false, foreign_key: true
      t.boolean   :is_cancel, null: false, default: false

      t.timestamps
    end
  end
end
