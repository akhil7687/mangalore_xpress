class CreateClassifieds < ActiveRecord::Migration[5.0]
  def change
    create_table :classifieds do |t|
      t.string :title
      t.text :description
      t.references :classified_category, foreign_key: true
      t.attachment :pic
      t.string :slug
      t.integer :status
      t.timestamps
    end
    add_index :classifieds, :slug
  end
end
