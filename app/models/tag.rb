# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  num_questions :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Tag < ActiveRecord::Base
  attr_accessible :name, :num_questions
  
  has_and_belongs_to_many :questions, uniq: true
  
  default_scope order(:id)
  
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
  
  def top_tags(num)
    self.first(num)
  end
end
