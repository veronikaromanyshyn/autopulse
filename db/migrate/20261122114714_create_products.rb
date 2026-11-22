class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.string :brand
      t.string :sku
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.decimal :old_price, precision: 10, scale: 2
      t.integer :stock, default: 0, null: false
      t.string :image
      t.string :compatibility
      t.boolean :featured, default: false

      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
