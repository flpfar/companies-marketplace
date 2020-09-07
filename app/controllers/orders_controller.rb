class OrdersController < ApplicationController
  before_action :must_be_buyer_or_seller, only: [:show]
  before_action :must_be_seller, only: [:complete, :cancel]

  def create
    @sale_post = SalePost.find(params[:sale_post_id])
    @order = Order.new(item_name: @sale_post.title, item_description: @sale_post.description, sale_post: @sale_post,
                       posted_price: @sale_post.price, status: :in_progress, buyer: current_user, 
                       seller: @sale_post.user)
    if @order.save
      redirect_to order_path(@order), notice: 'Solicitação de compra enviada. '\
                                                                      'Aguarde aprovação do vendedor'
    else
      redirect_back fallback_location: root_path, alert: 'Erro ao solicitar compra. Tente novamente mais tarde'
    end
  end

  def show
    @message = Message.new
  end

  def complete
    final_price = params[:final_price]
    order_final_price = final_price.present? ? final_price : @order.posted_price
    @order.update(status: :completed, final_price: order_final_price)
    @order.sale_post.disabled!
    @order.buyer.notifications.create(
      body: "O vendedor aceitou seu pedido de compra para '#{@order.item_name}'", path: order_path(@order)
    )
    redirect_to @order, notice: 'Venda finalizada com sucesso'
  end

  def cancel
    @order.canceled!
    @order.sale_post.enabled!
    @order.buyer.notifications.create(
      body: "O vendedor cancelou seu pedido de compra para '#{@order.item_name}'", path: order_path(@order)
    )
    redirect_to root_path, notice: 'Venda cancelada com sucesso'
  end

  private

  def must_be_seller
    @order = Order.find(params[:id])
    return redirect_to root_path if current_user != @order.seller
  end

  def must_be_buyer_or_seller
    @order = Order.find(params[:id])
    redirect_to root_path unless current_user == @order.buyer || current_user == @order.seller
  end
end
