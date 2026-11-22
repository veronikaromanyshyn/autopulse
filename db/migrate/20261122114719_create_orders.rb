class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :delivery_method, null: false, foreign_key: true
      t.string :number
      t.string :full_name
      t.string :phone
      t.string :email
      t.string :city
      t.string :address
      t.text :comment
      t.string :payment_method
      t.string :status, default: "new", null: false
      t.decimal :items_total, precision: 10, scale: 2
      t.decimal :delivery_cost, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.datetime :paid_at
      t.string :payment_reference
      t.string :card_last4

      t.timestamps
    end
    add_index :orders, :number, unique: true
  end
end
