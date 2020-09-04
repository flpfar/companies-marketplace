class CategoriesController < ApplicationController
  def index
    @categories = current_user.company.categories
  end

  def show
    @category = Category.find(params[:id])
  end
end
