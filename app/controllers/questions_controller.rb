class QuestionsController < ApplicationController
  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = 'Pergunta enviada com sucesso'
    else
      flash[:alert] = 'Falha ao enviar pergunta. Tente novamente mais tarde.'
    end
    redirect_to sale_post_path(params[:sale_post_id])
  end

  private

  def question_params
    params.require(:question).permit(:body).merge(sale_post_id: params[:sale_post_id], user_id: current_user.id)
  end
end
