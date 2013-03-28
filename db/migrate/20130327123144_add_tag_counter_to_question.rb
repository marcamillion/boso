class AddTagCounterToQuestion < ActiveRecord::Migration
  def up
    add_column :tags, :questions_count, :integer, default: 0, null: false
    rename_column :questions, :answers_count, :so_answers_count
    add_column :questions, :answers_count, :integer, default: 0, null: false
    
    t_ids = Set.new
    a_ids = Set.new

    Question.all.each do |q|
      t_ids << q.tag_ids
      q.answers_count = q.answers.count
    end
            
    t_ids.each do |tag_id|
       Tag.find(tag_id).first.questions_count = Tag.find(tag_id).first.questions.count
    end

  end
  
  def down
    remove_column :questions, :answers_count
    rename_column :questions, :so_answers_count, :answers_count
    remove_column :tags, :questions_count
  end
    
end