# == Schema Information
#
# Table name: answers
#
#  id            :integer          not null, primary key
#  so_id         :integer
#  creation_date :datetime
#  is_accepted   :boolean
#  question_id   :integer
#  owner         :string(255)
#  score         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  body          :text
#

class Answer < ActiveRecord::Base
  attr_accessible :creation_date, :is_accepted, :owner, :question_id, :score, :so_id, :body
  
  belongs_to :question
  
  default_scope order(:id)
end
