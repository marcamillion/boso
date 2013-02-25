class RemoveNumAnswersFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :num_answers
  end
end
