class CreateEnquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :enquiries do |t|
      t.string :user_name
      t.string :user_email
      t.string :user_phone
      t.references :service_category, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
