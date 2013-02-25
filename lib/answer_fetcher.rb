module AnswerFetcher

  def self.get_answer(id)
    answer = Serel::Answer.find(id)
  end

end