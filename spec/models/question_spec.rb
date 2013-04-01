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

require 'spec_helper'

describe Question do
  pending "add some examples to (or delete) #{__FILE__}"
end
