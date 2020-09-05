class SalePostsController < ApplicationController
  before_action :user_must_be_enabled, only: [:new, :create]

  def show
    @sale_post = SalePost.find(params[:id])
    @comment = Comment.new
  end

  def new
    @sale_post = SalePost.new
    @categories = Category.where(company_id: current_user.company_id)
    if @categories.empty?
      message = 'Não há categorias cadastradas na sua empresa. Contate o administrador'
      redirect_to root_path, alert: message
    end
  end

  def create
    @sale_post = SalePost.new(sale_post_params)
    @categories = current_user.company.categories

    if @categories.empty?
      message = 'Não há categorias cadastradas na sua empresa. Contate o administrador'
      redirect_to root_path, alert: message
      return
    end

    if @sale_post.save
      redirect_to @sale_post, notice: 'Anúncio criado com sucesso'
    else
      render :new
    end
  end

  def search
    @keyword = params[:q]
    @posts = SalePost.where('title LIKE ? OR description LIKE ?', "%#{@keyword}%", "%#{@keyword}%")
  end

  private

  def sale_post_params
    params.require(:sale_post).permit(:title, :description, :price, :category_id).merge(user_id: current_user.id)
  end

  def user_must_be_enabled
    return if current_user.enabled?

    redirect_to root_path, alert: 'Para criar um anúncio seu perfil deve estar preenchido'
  end
end
