class CreateServiceProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :service_providers do |t|
      t.string :name
      t.text :description
      t.string :speciality
      t.string :contact_no
      t.attachment :pic
      t.references :service_category, foreign_key: true
      t.boolean :enable

      t.timestamps
    end
  end
end
