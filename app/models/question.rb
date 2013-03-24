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
  
  has_many :answers, :dependent => :destroy
  has_and_belongs_to_many :tags, before_add: :validates_tag
  
  def validates_tag(tag)
    self.tags.include? tag
  end
  
  def self.update_top_questions
    tags = []
    tag_list = []
    answer_list = []
    i = 1
    1.times do
    # 12.times do
      api_results = QuestionFetcher.fetch_top_questions(i)
        api_results.each do |q|
          
          puts "*" * 20 + " QUESTION from QuestionFetcher " + "*" * 20
          ap q
          puts "*" * 20 + " QUESTION from QuestionFetcher " + "*" * 20            
          
            q.tags.each do |t|
              if t == 'logarithm'
                tags << Tag.where(:name => 'logarithm')
              else
                tags << TagFetcher.find_tag(t)
              end
            end
            
            puts "*" * 20 + "Tags from TagFetcher" + "*" * 20
            ap tags
            puts "*" * 20 + "Tags from TagFetcher" + "*" * 20            
                        
            tags.each do |tag|
              tag_list << Tag.where(:name => tag.name).first_or_create(:num_questions => tag.count)
            end

            puts "*" * 20 + "Tag_List" + "*" * 20
            ap tag_list
            puts "*" * 20 + "Tag_List" + "*" * 20            
            
            answers = q.answers.filter(:withbody).pagesize(2).sort('votes').get
            
            answers.each do |a|
              answer_list << Answer.where(:so_id => a.answer_id).first_or_create(:creation_date => a.creation_date, :is_accepted => a.is_accepted, :score => a.score, :owner => a.owner.display_name, :body => a.body)
            end
            
            # puts "*" * 20 + "BEFORE answer_list" + "*" * 20
            # ap answer_list
            # puts "*" * 20 + "BEFORE answer_list" + "*" * 20
            
                    
            qq = Question.where(:so_id => q.question_id).first_or_create do |question|
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
              question.answers << answer_list
            end

            
            qq.update_attributes(score: q.score, view_count: q.view_count, answer_count: q.answer_count, is_answered: q.is_answered)
            qq.tags.replace(tag_list)
            
            puts "*" * 20 + "BEFORE # qq.answers UPDATE" + "*" * 20
            ap qq.answers.count
            puts "*" * 20 + "BEFORE # qq.answers UPDATE" + "*" * 20
            
            
            qq.answers.replace(answer_list)

            puts "*" * 20 + "AFTER # of qq.answers UPDATE -- BEGINNING " + "*" * 20
            ap qq.answers.count
            puts "*" * 20 + "AFTER # of qq.answers UPDATE -- END " + "*" * 20
            
            # Clear arrays to prevent duplication in all subsequent questions.         

            tags = []
            tag_list = []
            answers = []
            answer_list = [] 
        
            # puts "*" * 20 + "AFTER tag_list" + "*" * 20
            # ap tag_list
            # puts "*" * 20 + "AFTER tag_list" + "*" * 20

                     
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
  
  def self.first
    order(:id).limit(1)
  end
  
  def self.top_questions(num)
    order("score DESC").first(num)
  end
  
  def self.tagged_with(tag)
      Tag.find_by_name!(tag).questions.order("score DESC")
  end
  
  def trim_answer_numbers
    accepted_answer = self.answers.where(:is_accepted => true)
    top_answers = self.answers.order(:score).first(2)
    self.answers.replace(top_answers)
    self.answers << accepted_answer
  end
  
  # def update_tags(tag_list)
  #   # This is one way to achieve it
  #   self.tags = self.tags && tag_list
  #   
  #   # Another way to achieve it is simply
  #   self.tags = tag_list
  # 
  # end
  
end
