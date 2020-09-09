class MyAccountController < ApplicationController
  def show
    @user = current_user
  end

  def history
    @sale_orders = current_user.sale_orders.where.not(status: :in_progress)
    @buy_orders = current_user.buy_orders.where.not(status: :in_progress)
  end

  def sale_posts
    @posts = current_user.sale_posts.with_attached_cover.includes([:category])
  end
end
