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
  
  def self.update_tags(num_results, page_num)
    api_results = TagFetcher.fetch_tags(num_results, page_num)

    api_results.each do |t|
      Tag.where(:name => t.name).first_or_create(:num_questions => t.count)
    end
  end
end
