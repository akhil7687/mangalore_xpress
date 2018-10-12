class AddAdTypeToAds < ActiveRecord::Migration[5.0]
  def change
    add_column :ads, :ad_type, :string,:default=>"General"
  end
end
