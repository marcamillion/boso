# == Schema Information
#
# Table name: questions
#
#  id                    :integer          not null, primary key
#  so_id                 :integer
#  creation_date         :datetime
#  score                 :integer
#  accepted_answer_so_id :integer
#  title                 :string(255)
#  view_count            :integer
#  link                  :string(255)
#  body                  :text
#  answer_count          :integer
#  is_answered           :boolean
#  owner                 :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  accepted_answer_id    :integer
#

class Question < ActiveRecord::Base
  attr_accessible :accepted_answer_so_id, :answer_count, :body, :creation_date, :is_answered, :link, :owner, :score, :so_id, :title, :view_count
  
  has_many :answers
  has_and_belongs_to_many :tags, before_add: :validates_tag
  
  def validates_tag(tag)
    raise ActiveRecord::Rollback if self.tags.include? tag
  end
  
  def self.update_top_questions
    tags = []
    tag_list = []
    answer_list = []
    i = 1
    20.times do
      api_results = QuestionFetcher.fetch_top_questions(i)
        api_results.each do |q|
            q.tags.each do |t|
              tags << TagFetcher.find_tag(t)
            end
            
            tags.each do |tag|
              # Have to redo this tag_list addition because it keeps adding new tags to the existing array - you can see that by looking at the main page where the same tags are repeated for the top5 questions....so it is likely that the tags cascade.
              tag_list << Tag.where(:name => tag.name).first_or_create(:num_questions => tag.count)
            end
            
            answers = q.answers.filter(:withbody).sort('votes').get
            
            answers.each do |a|
              answer_list << Answer.where(:so_id => a.answer_id).first_or_create(:creation_date => a.creation_date, :is_accepted => a.is_accepted, :score => a.score, :owner => a.owner.display_name, :body => a.body)
            end
        
            Question.where(:so_id => q.question_id).first_or_create do |question|
              question.creation_date = q.creation_date
              question.score = q.score
              question.accepted_answer_so_id = q.accepted_answer_id 
              question.title = q.title 
              question.view_count = q.view_count 
              question.link = q.link 
              question.body = q.body
              question.answer_count = q.answer_count
              question.is_answered = q.is_answered
              question.owner = q.owner.display_name
              question.tags << tag_list
              question.answers << Answer.where(:question_id => question.id)
            end
             
        end
      i += 1      
      break if api_results.empty?
      
      
    end
        
  end
  
  def update_top_questions_for_tag(tag, num)
    api_results = QuestionFetcher.fetch_top_tagged_questions(tag, num)
    
    # add some code to update 
    # the top questions for a particular tag in the system
    
  end
  
  def self.top_questions(num)
    self.order("score DESC").first(num)
  end
  
  def self.tagged_with(tag)
    tags.where(:name => tag)
  end
  
end
