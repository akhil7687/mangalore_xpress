class AddLanguageToFeeds < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :language, :string, :default=>"English"
  end
end
