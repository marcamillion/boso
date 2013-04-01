module AnswerFetcher

  def self.get_answer(id)
    answer = Serel::Answer.find(id)
  end
  
  def self.fetch_answers(question_id)
    Serel::Question.find(question_id).answers.filter(:withbody).sort('votes').get
  end

  def self.fetch_top_answer(question_id)
    Serel::Question.find(question_id).answers.filter(:withbody).pagesize(1).sort('votes').get
  end

end