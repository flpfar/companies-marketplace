class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = SalePost.all
  end
end
