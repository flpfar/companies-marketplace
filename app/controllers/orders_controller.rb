class OrdersController < ApplicationController
  before_action :must_be_buyer_or_seller, only: [:show]

  def create
    @sale_post = SalePost.find(params[:sale_post_id])
    @order = Order.new(item_name: @sale_post.title, item_description: @sale_post.description, sale_post: @sale_post,
                       posted_price: @sale_post.price, status: :in_progress, buyer: current_user, 
                       seller: @sale_post.user)
    if @order.save
      @sale_post.user.notifications.create!(body: "Solicitação de compra pendente em anúncio #{@sale_post.title}",
                                            path: order_path(@order))
      @sale_post.disabled!
      redirect_to order_path(@order), notice: 'Solicitação de compra enviada. '\
                                                                      'Aguarde aprovação do vendedor'
    else
      flash[:alert] = 'Erro ao solicitar compra. Tente novamente mais tarde'
      redirect_back fallback_location: root_path
    end
  end

  def show; end

  def complete
    @order = Order.find(params[:id])
    return redirect_to root_path if current_user != @order.seller

    @order.completed!
    @order.sale_post.disabled!
    @order.buyer.notifications.create(
      body: "O vendedor aceitou seu pedido de compra para '#{@order.item_name}'", path: order_path(@order)
    )
    redirect_to root_path, notice: 'Venda finalizada com sucesso'
  end

  private

  def must_be_buyer_or_seller
    @order = Order.find(params[:id])
    redirect_to root_path unless current_user == @order.buyer || current_user == @order.seller
  end
end
