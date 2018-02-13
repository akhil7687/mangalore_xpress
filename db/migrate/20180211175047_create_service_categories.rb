class CreateServiceCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :service_categories do |t|
      t.string :name
      t.string :description
      t.boolean :enable
      t.attachment :icon_img
      t.attachment :cover_img
      t.timestamps
    end
  end
end
