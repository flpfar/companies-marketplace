class UsersController < ApplicationController
  def profile
    @user = User.find(params[:id])
    @posts = @user.sale_posts.enabled.with_attached_cover.includes([:category])
  end
end
