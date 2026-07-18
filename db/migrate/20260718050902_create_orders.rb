class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :number, null: false, limit: 20
      t.string :customer_name, null: false, limit: 255
      t.string :customer_phone, null: false, limit: 30
      t.text :customer_address, null: false
      t.string :payment_method, null: false, limit: 20
      t.string :status, null: false, default: "pending"
      t.integer :total_cents, null: false

      t.timestamps
    end

    add_index :orders, :number, unique: true
    add_index :orders, :status
  end
end
