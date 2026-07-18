class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :category, null: true, foreign_key: true
      t.string :name, null: false, limit: 255
      t.string :slug, null: false, limit: 255
      t.text :description
      t.integer :price_cents, null: false
      t.integer :stock, null: false, default: 0
      t.string :status, null: false, default: "active"

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :status
  end
end
