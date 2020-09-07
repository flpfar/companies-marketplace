class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    return redirect_to new_user_session_path unless user_signed_in?

    @posts = current_user.company.sale_posts.enabled
  end
end
