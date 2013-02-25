class AddIndexesToQuestionsTagsAnswers < ActiveRecord::Migration
  def change
    add_index :answers, :so_id
    add_index :answers, :question_id
    add_index :questions, :so_id    
    add_index :questions, :accepted_answer_so_id    
    add_index :questions, :title        
    add_index :questions_tags, :question_id    
    add_index :questions_tags, :tag_id        
    add_index :tags, :name        
  end
end
