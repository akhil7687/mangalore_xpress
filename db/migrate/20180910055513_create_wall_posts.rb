class CreateWallPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :wall_posts do |t|
      t.references :user, foreign_key: true
      t.attachment :photo
      t.integer :status, :default=>1

      t.timestamps
    end
  end
end
