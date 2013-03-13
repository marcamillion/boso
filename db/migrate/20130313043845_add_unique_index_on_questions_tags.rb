class AddUniqueIndexOnQuestionsTags < ActiveRecord::Migration
  def up
    add_index :questions_tags, [:question_id, :tag_id], unique: true, name: 'by_question_and_tag'
  end

  def down
    remove_index :questions_tags, [:question_id, :tag_id]
  end
end
