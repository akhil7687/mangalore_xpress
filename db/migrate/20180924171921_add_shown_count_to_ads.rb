class AddShownCountToAds < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :shown_count, :integer, :default=>0
  end
end
