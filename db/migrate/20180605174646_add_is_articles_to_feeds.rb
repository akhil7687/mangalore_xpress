class AddIsArticlesToFeeds < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :is_article, :boolean, :default=>false
  end
end
