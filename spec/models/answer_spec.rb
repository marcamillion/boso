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

require 'spec_helper'

describe Answer do
  pending "add some examples to (or delete) #{__FILE__}"
end
