class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.integer :mrp
      t.references :store, foreign_key: true
      t.boolean :enable
      t.attachment :product_image
      t.timestamps
    end
  end
end
