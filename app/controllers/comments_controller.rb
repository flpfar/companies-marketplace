class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:notice] = 'Comentário criado com sucesso'
    else
      flash[:alert] = 'Falha ao criar comentário. Tente novamente mais tarde.'
    end
    redirect_to sale_post_path(params[:sale_post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(sale_post_id: params[:sale_post_id], user_id: current_user.id)
  end
end
