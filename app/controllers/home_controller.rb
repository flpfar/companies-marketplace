class HomeController < ApplicationController
  def index
    @posts = current_user.company.sale_posts
  end
end
