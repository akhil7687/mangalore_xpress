class CreateContestRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :contest_registrations do |t|
      t.references :contest, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
