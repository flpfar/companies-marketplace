class DashboardController < ApplicationController
  before_action :must_be_admin

  def show
    @companies = Company.all.order(name: :asc)
  end
end
