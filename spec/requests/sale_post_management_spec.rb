require 'rails_helper'

describe 'Sale post management' do
  context 'index' do
    it 'renders enabled sale posts in company' do
      company = Company.create!(name: 'Company', domain: 'company.com')
      games_category = company.categories.create!(name: 'Games')
      eletro_category = company.categories.create!(name: 'Eletrodomésticos')
      user = User.create!(name: 'User', email: 'user@company.com', password: '123123')
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
