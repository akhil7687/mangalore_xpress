class CreateAds < ActiveRecord::Migration[5.0]
  def change
    create_table :ads do |t|
      t.attachment :ad_img
      t.boolean :enable

      t.timestamps
    end
  end
end
