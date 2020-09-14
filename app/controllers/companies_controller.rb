class CompaniesController < ApplicationController
  before_action :must_be_admin

  def show
    @company = Company.find(params[:id])
    @categories = @company.categories.order(name: :asc)
    @category = @company.categories.new
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to dashboard_path, notice: 'Empresa criada com sucesso!'
    else
      flash.now[:alert] = 'Falha ao criar empresa'
      render :new
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :domain)
  end
end
