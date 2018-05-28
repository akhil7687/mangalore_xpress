class CreateMarketPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :market_prices do |t|
      t.string :name
      t.string :item_id
      t.string :item_group
      t.timestamps
    end
  end
end
