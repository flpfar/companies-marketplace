class OrdersController < ApplicationController
  def create
    @sale_post = SalePost.find(params[:sale_post_id])
    @order = Order.new(item_name: @sale_post.title, item_description: @sale_post.description, sale_post: @sale_post,
                       posted_price: @sale_post.price, status: :in_progress)
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

  def show
    @order = Order.find(params[:id])
  end

  private

end
