class HomeController < ApplicationController
  def index
    @users = User.all
    @top_5_questions = Question.top_questions(5)
    # @top_ruby_questions = Tag.where(:name => "ruby").questions.uniq.top_questions(5)
  end
end
