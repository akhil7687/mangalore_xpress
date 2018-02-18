class AddSlugToServiceCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :service_categories, :slug, :string
    add_index :service_categories, :slug
  end
end
