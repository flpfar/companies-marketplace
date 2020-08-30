class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = current_user.company.sale_posts
  end
end
