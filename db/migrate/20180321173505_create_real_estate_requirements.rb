class CreateRealEstateRequirements < ActiveRecord::Migration[5.0]
  def change
    create_table :real_estate_requirements do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :property_type
      t.string :property_detail
      t.string :budget
      t.string :pref_area
      t.string :remarks, :limit => 3000

      t.timestamps
    end
  end
end
