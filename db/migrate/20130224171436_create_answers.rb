class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :so_id
      t.datetime :creation_date
      t.boolean :is_accepted
      t.integer :question_id
      t.string :owner
      t.integer :score

      t.timestamps
    end
  end
end
