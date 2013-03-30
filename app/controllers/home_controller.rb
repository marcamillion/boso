class HomeController < ApplicationController
  def index
      @questions = Question.paginate(:page => params[:page], :per_page => 10).includes(:tags).order("score DESC")    

    # @top_5_questions = Question.top_questions(5)
    # @top_ruby_questions = Tag.where(:name => "ruby").questions.uniq.top_questions(5)
  end
end
