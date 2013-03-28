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

require 'spec_helper'

describe Tag do
  pending "add some examples to (or delete) #{__FILE__}"
end
