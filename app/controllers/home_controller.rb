class HomeController < ApplicationController
  def index
    
    if params[:tag]
      @questions = Question.paginate(:page => params[:page]).tagged_with(params[:tag]).includes(:tags).order("score DESC")
    else
      @questions = Question.paginate(:page => params[:page]).includes(:tags).order("score DESC")
    end

    # @top_5_questions = Question.top_questions(5)
    # @top_ruby_questions = Tag.where(:name => "ruby").questions.uniq.top_questions(5)
  end
end
