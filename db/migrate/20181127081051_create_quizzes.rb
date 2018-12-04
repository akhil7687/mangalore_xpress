class CreateQuizzes < ActiveRecord::Migration[5.0]
  def change
    create_table :quizzes do |t|
      t.string :quiz_name
      t.integer :status

      t.timestamps
    end
  end
end
