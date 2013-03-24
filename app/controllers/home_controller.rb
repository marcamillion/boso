class HomeController < ApplicationController
  def index
    
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.top_questions(30)
    end

    # @users = User.all
    # @top_5_questions = Question.top_questions(5)
    # @top_ruby_questions = Tag.where(:name => "ruby").questions.uniq.top_questions(5)
  end
end
