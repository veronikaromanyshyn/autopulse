class CreateDeliveryMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :delivery_methods do |t|
      t.string :name
      t.string :code
      t.decimal :price, precision: 10, scale: 2
      t.decimal :free_from, precision: 10, scale: 2
      t.string :description
      t.integer :position

      t.timestamps
    end
    add_index :delivery_methods, :code, unique: true
  end
end
