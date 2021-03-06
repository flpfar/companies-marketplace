class MyAccountController < ApplicationController
  def show
    @user = current_user
    @notifications_unseen = @user.notifications.unseen.order(created_at: :desc)
    @sale_orders = current_user.sale_orders.in_progress.includes([:buyer])
    @buy_orders = current_user.buy_orders.in_progress.includes([:seller, :buyer])
  end

  def history
    @sale_orders = current_user.sale_orders.where.not(status: :in_progress).includes([:buyer])
    @buy_orders = current_user.buy_orders.where.not(status: :in_progress).includes([:seller, :buyer])
  end

  def sale_posts
    @posts = current_user.sale_posts.with_attached_cover.includes([:category])
  end
end
