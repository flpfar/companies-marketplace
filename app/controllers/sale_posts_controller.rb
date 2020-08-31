class SalePostsController < ApplicationController
  before_action :user_must_be_enabled
  def new
  end

  def create
  end

  private

  def user_must_be_enabled
    return if current_user.enabled?

    redirect_to root_path, alert: 'Para criar um anúncio seu perfil deve estar preenchido'
  end
end
