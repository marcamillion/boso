# == Schema Information
#
# Table name: tags
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  num_questions   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  questions_count :integer          default(0), not null
#

class Tag < ActiveRecord::Base
  attr_accessible :name, :num_questions, :questions_count
  
  has_and_belongs_to_many :questions, uniq: true
  
  extend FriendlyId
  friendly_id :name#, use: :slugged
  
  def self.update_tags
    i = 1
    loop do
      api_results = TagFetcher.fetch_tags(i)
      api_results.each do |t|
        Tag.where(:name => t.name).first_or_create(:num_questions => t.count)
      end      
      i += 1
      break if api_results.empty?
    end
  end
  
  def self.top_tags(num)
    order("num_questions DESC").limit(num)
  end
  
  def self.navigation_tags
    nav_tags = []
    ['ruby-on-rails', 'python', 'c++', 'java', 'iphone', 'android', 'javascript', 'c#', 'php', 'css3', 'algorithm'].each do |t|
      nav_tags << Tag.where(:name => t).first
    end
    nav_tags
  end
  
  def reset_questions_count
    Tag.all.each do |t|
      question_count = t.questions.count
      t.update_attributes(:questions_count => question_count)
    end
  end  
  
end
