class HomeController < ApplicationController
  def index
    
    if params[:tag]
      @questions = Question.tagged_with(params[:tag]).includes(:tags)
    else
      @questions = Question.includes(:tags).top_questions(30)
    end

    # @top_5_questions = Question.top_questions(5)
    # @top_ruby_questions = Tag.where(:name => "ruby").questions.uniq.top_questions(5)
  end
end
