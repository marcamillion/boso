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
#  so_answer_count       :integer
#  is_answered           :boolean
#  owner                 :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  accepted_answer_id    :integer
#  answers_count         :integer          default(0), not null
#

class Question < ActiveRecord::Base
  attr_accessible :accepted_answer_so_id, :so_answer_count, :body, :creation_date, :is_answered, :link, :owner, :score, :so_id, :title, :view_count, :answers_count, :accepted_answer_id
  
  has_many :answers, :dependent => :destroy
  has_and_belongs_to_many :tags, before_add: :validates_tag
  
  after_create :incrememnt_tags_counter
  after_destroy :decrement_tags_counter  
  
  def validates_tag(tag)
    self.tags.include? tag
  end
  
  def self.update_top_questions
    tags = []
    tag_list = []
    answer_list = []
    i = 12
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
              elsif t == 'c#'
                tags << Tag.where(:name => 'c#')
              elsif t == 'c#-4.0'
                tags << Tag.where(:name => 'c#-4.0')
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
            
            answers = q.answers.filter(:withbody).pagesize(1).sort('votes').get
            
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
              question.answers_count = q.answers_count
              question.is_answered = q.is_answered
              question.owner = q.owner.display_name
              question.tags << tag_list
              question.answers << answer_list
            end

            
            qq.update_attributes(score: q.score, view_count: q.view_count, so_answer_count: q.answer_count, is_answered: q.is_answered)
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
  
  def self.first(num)
    order(:id).limit(num)
  end
  
  def self.top_questions(num)
    order("score DESC").first(num)
  end
  
  def self.tagged_with(tag)
      Tag.find_by_name!(tag).questions.order("score DESC")
  end
  
  def trim_answers
    ## Need to do the case where no answers in db, even though there are answers on SO & no accepted_answer
    if self.answers.where(is_accepted: true)
      accepted_answer = self.answers.where(is_accepted: true)
      self.answers.replace(accepted_answer)
    else
      top_answer = self.answers.order(:score).first(1).first      
      self.answers.replace(top_answer)
    end
    # self.answers << accepted_answer
  end
  
  
  
  def increment_tags_counter
    self.tags.each do |t|
      Tag.find_by_name(t.name).questions_count += 1
    end
  end

  ## I haven't tested the callback on this, but it should work. What I am not 100% sure of is if the record is saved even
  ## a destroy, such that we can call `self.tags` on that same record and it works. If it doesn't work, then this can just
  ## be moved to a 'before_destroy'.

  def decrement_tags_counter
    self.tags.each do |t|
      Tag.find_by_name(t.name).questions_count -= 1
    end
  end
  
  def self.reset_all_answers_counters
    Question.all.each do |q|
      Question.reset_counters(q.id, :answers)
    end
  end
  
  def selected_answer
    Answer.find(self.accepted_answer_id)
  end
  
  def displayed_answer
    Answer.find_by_so_id(self.accepted_answer_so_id) || self.answers.order("score DESC").first
  end
  
  def update_selected_answer
    # Need to run this method on the set of questions that have a non nil value for 'accepted_answer_so_id'.
    # i.e. on a collection returned by `Question.where("accepted_answer_so_id > 0")`

    if Answer.find_by_so_id(self.accepted_answer_so_id)
      self.update_attributes(accepted_answer_id: Answer.find_by_so_id(self.accepted_answer_so_id).id)
    end
  end
  
  def add_missing_answers
    # Need to run this method on the set of questions that have a nil value for 'accepted_answer_id'.
    # i.e. on a collection returned by `Question.where(:accepted_answer_id => nil)`
    answers = []
    
    if self.answers_count == 0
      answers = AnswerFetcher.fetch_top_answer(self.so_id)
      answers.each do |a|
        self.answers << Answer.where(:so_id => a.answer_id).first_or_create(:creation_date => a.creation_date, :is_accepted => a.is_accepted, :score => a.score, :owner => a.owner.display_name, :body => a.body)
      end
      Question.increment_counter(:answer_count, self.id)
    end
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
