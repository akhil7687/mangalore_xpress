class AddImageUrlToFeeds < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :image_url, :string
    add_column :feeds, :src_url, :string
  end
end
