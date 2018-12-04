class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.references :quiz, foreign_key: true
      t.text :qn
      t.text :optn_a
      t.text :optn_b
      t.text :optn_c
      t.text :optn_d
      t.integer :correct_ans

      t.timestamps
    end
  end
end
