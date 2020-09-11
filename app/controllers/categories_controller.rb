class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @posts = @category.sale_posts.enabled.with_attached_cover.order(created_at: :desc)
  end
end
