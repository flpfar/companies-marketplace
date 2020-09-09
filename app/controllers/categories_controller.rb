class CategoriesController < ApplicationController
  def index
    @categories = current_user.company.categories
  end

  def show
    @category = Category.find(params[:id])
    @posts = @category.sale_posts.enabled.with_attached_cover.order(created_at: :desc)
  end
end
