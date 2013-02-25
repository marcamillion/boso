class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :so_id
      t.datetime :creation_date
      t.integer :score
      t.integer :num_answers
      t.integer :accepted_answer_so_id
      t.string :title
      t.integer :view_count
      t.string :link
      t.text :body
      t.integer :answer_count
      t.boolean :is_answered
      t.string :owner

      t.timestamps
    end
  end
end
