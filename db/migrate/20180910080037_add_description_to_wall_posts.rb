class AddDescriptionToWallPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :wall_posts, :description, :string, :limit=>10000
  end
end
