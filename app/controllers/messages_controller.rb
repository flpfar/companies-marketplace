class MessagesController < ApplicationController
  def create
    message = Message.new(message_params)
    return redirect_to order_path(params[:order_id]), alert: 'Mensagem deve conter texto' if message.body.empty?

    if message.save!
      flash[:notice] = 'Mensagem enviada com sucesso'
    else
      flash[:alert] = 'Falha ao enviar mensagem. Tente novamente mais tarde.'
    end
    redirect_to order_path(params[:order_id])
  end

  private

  def message_params
    params.require(:message).permit(:body).merge(order_id: params[:order_id], user_id: current_user.id)
  end
end
