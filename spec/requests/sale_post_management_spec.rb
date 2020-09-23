require 'rails_helper'

describe 'Sale post management' do
  context 'index' do
    it 'renders enabled sale posts in company' do
      company = FactoryBot.create(:company)
      games_category = FactoryBot.create(:category, company: company)
      eletro_category = FactoryBot.create(:category, company: company, name: 'Eletro')
      user = FactoryBot.create(:user)
      user.sale_posts.create!(title: 'Playstation 4', description: 'Novo na caixa', category: games_category,
                              price: 1200)
      user.sale_posts.create!(title: 'Xbox One', description: 'Recondicionado', category: games_category,
                              price: 1000, status: :disabled)
      user.sale_posts.create!(title: 'Freezer', description: 'Freezer recondicionado, semi novo',
                              category: eletro_category, price: 600)

      get "/api/v1/company/#{company.id}/sale_posts"

      expect(response).to have_http_status(200)
      expect(response.body).to include('Playstation 4')
      expect(response.body).to include('Freezer')
      expect(response.body).not_to include('Xbox One')
    end
  end
end
