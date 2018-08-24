class AddCategoryToFeeds < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :category, :string
    add_index :feeds, :category
  end
end
