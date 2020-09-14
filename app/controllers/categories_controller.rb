class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @posts = @category.sale_posts.enabled.with_attached_cover.order(created_at: :desc)
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to dashboard_company_path(@category.company), notice: 'Categoria criada com sucesso'
    else
      redirect_to dashboard_company_path(@category.company), alert: 'Falha ao criar categoria'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name).merge(company_id: params[:company_id])
  end
end
