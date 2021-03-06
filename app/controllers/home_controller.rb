class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    return redirect_to new_user_session_path unless user_signed_in?

    @posts = current_user.company.sale_posts.enabled.with_attached_cover.includes([:category]).order(created_at: :desc)
    @categories = current_user.company.categories.order(name: :asc)
  end
end
