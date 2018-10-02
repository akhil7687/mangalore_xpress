class CreateProductPictures < ActiveRecord::Migration[5.0]
  def change
    create_table :product_pictures do |t|
      t.references :product, foreign_key: true
      t.attachment :pic

      t.timestamps
    end
  end
end
