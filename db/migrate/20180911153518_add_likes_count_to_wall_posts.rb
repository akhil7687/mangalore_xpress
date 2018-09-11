class AddLikesCountToWallPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :wall_posts, :likes_count, :integer
  end
end
