module QuestionFetcher

  def self.fetch_top_tagged_questions(tag, num)
    top_tagged_questions = Serel::Question.search.filter(:withbody).tagged(tag.name).pagesize(num).sort('votes').get
  end

  def self.fetch_top_questions(page_num)
    top_questions = Serel::Question.filter(:withbody).pagesize(50).page(page_num).sort('votes').get
  end
  
end