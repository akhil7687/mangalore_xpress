class IncreaseDesc < ActiveRecord::Migration[5.0]
  def change
    change_column :feeds, :description, :blob
  end
end
