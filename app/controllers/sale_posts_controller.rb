class SalePostsController < ApplicationController
  before_action :user_must_be_enabled, only: [:new, :create]
  before_action :user_must_be_the_author, only: [:edit, :update, :destroy]
  before_action :user_must_be_seller_if_post_is_not_enabled, only: [:show]

  def show
    @order_in_progress = current_user.buying_order_in_progress_at_sale_post(@sale_post)
    @questions = @sale_post.questions.includes([:user, :answer])
    @question = Question.new
    @answer = Answer.new
  end

  def new
    @sale_post = SalePost.new
    @categories = Category.where(company_id: current_user.company_id)
    return unless @categories.empty?

    redirect_to root_path, alert: 'Não há categorias cadastradas na sua empresa. Contate o administrador'
  end

  def create
    @sale_post = SalePost.new(sale_post_params)
    @categories = current_user.company.categories.order(name: :asc)

    if @categories.empty?
      flash[:alert] = 'Não há categorias cadastradas na sua empresa. Contate o administrador'
      return redirect_to root_path
    end

    @sale_post.save ? redirect_to(@sale_post, notice: 'Anúncio criado com sucesso') : render(:new)
  end

  def edit
    @categories = current_user.company.categories.order(name: :asc)
  end

  def update
    if @sale_post.update(sale_post_params)
      redirect_to @sale_post, notice: 'Anúncio atualizado com sucesso'
    else
      render :edit
    end
  end

  def search
    @keyword = params[:q]
    @posts = SalePost.where(
      'title LIKE ? OR description LIKE ? AND status = ?', "%#{@keyword}%", "%#{@keyword}%", SalePost.statuses[:enabled]
    )
  end

  def enable
    @post = SalePost.find(params[:id])

    return redirect_to sale_post_path(@post) if current_user != @post.user

    @post.enabled!
    redirect_to @post, notice: 'Anúncio reativado com sucesso'
  end

  def disable
    @post = SalePost.find(params[:id])

    return redirect_to sale_post_path(@post) if current_user != @post.user

    unless @post.orders.in_progress.empty?
      flash[:alert] = 'Este anúncio possui pedidos de compra pendentes. Finalize-os primeiro e tente novamente'
      return redirect_to sale_post_path(@post)
    end

    @post.disabled!
    redirect_to sale_post_path(@post), notice: 'Anúncio desativado com sucesso'
  end

  def destroy
    unless @sale_post.orders.empty?
      flash[:alert] = 'Falha ao excluir anúncio. Este anúncio possui pedidos de compra'
      return redirect_to sale_post_path(@sale_post)
    end

    if @sale_post.destroy
      redirect_to root_path, notice: 'Anúncio excluído com sucesso'
    else
      redirect_to sale_post_path(@sale_post), 'Falha ao excluir anúncio. Tente novamente mais tarde'
    end
  end

  private

  def sale_post_params
    params
      .require(:sale_post)
      .permit(:title, :description, :price, :category_id, :cover)
      .merge(user_id: current_user.id)
  end

  def user_must_be_enabled
    return if current_user.enabled?

    redirect_to root_path, alert: 'Para criar um anúncio seu perfil deve estar preenchido'
  end

  def user_must_be_the_author
    @sale_post = SalePost.find(params[:id])
    return redirect_to root_path, alert: 'Acesso negado' unless @sale_post.user == current_user
  end

  def user_must_be_seller_if_post_is_not_enabled
    @sale_post = SalePost.find(params[:id])
    redirect_to root_path, alert: 'Anúncio indisponível' if !@sale_post.enabled? && @sale_post.user != current_user
  end
end
