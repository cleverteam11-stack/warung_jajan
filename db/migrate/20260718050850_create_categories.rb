class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 255
      t.string :slug, null: false, limit: 255

      t.timestamps
    end

    add_index :categories, :slug, unique: true
  end
end
