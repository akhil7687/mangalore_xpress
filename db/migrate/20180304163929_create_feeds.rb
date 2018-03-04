class CreateFeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :description, :limit => 5000
      t.attachment :pic
      t.boolean :status

      t.timestamps
    end
  end
end
