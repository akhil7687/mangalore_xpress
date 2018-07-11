class AddNewsSourceToFeeds < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :news_source, :string
    add_column :feeds, :published_date, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
