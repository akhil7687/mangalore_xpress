class AddCommentsCountToWallPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :wall_posts, :comments_count, :integer, :default=>0
  end
end
