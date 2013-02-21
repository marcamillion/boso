class HomeController < ApplicationController
  def index
    @users = User.all
    @tags = Serel::Tag.pagesize(100).get        
  end
end
