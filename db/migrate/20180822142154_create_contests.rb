class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.string :name
      t.attachment :pic
      t.boolean :status
      t.string :btn_text

      t.timestamps
    end
  end
end
