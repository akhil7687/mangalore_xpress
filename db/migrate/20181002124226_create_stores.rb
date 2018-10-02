class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :description
      t.attachment :store_logo
      t.boolean :enable

      t.timestamps
    end
  end
end
