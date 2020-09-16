class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)

    return redirect_to sale_post_path(params[:sale_post_id]), alert: 'Resposta deve conter texto' if @answer.body.empty?

    if @answer.save!
      flash.notice = 'Resposta enviada com sucesso'
    else
      flash.alert = 'Falha ao enviar resposta. Tente novamente'
    end

    redirect_to sale_post_path(params[:sale_post_id])
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(question_id: params[:question_id])
  end
end
