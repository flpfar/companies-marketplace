require 'rails_helper'

feature 'User searches posts' do
  context 'successfully' do
    scenario 'by title' do
      company = Company.create!(name: 'Company', domain: 'company.com')
      games_category = company.categories.create!(name: 'Games')
      user = User.create!(name: 'User', social_name: 'User', email: 'user@company.com', password: '123123')
      post_play = user.sale_posts.create!(title: 'Playstation 4', description: 'Novo na caixa', category: games_category,
                                          price: 1200)
      post_xbox = user.sale_posts.create!(title: 'Xbox One', description: 'Recondicionado', category: games_category,
                                          price: 1000)

      login_as user, scope: :user
      visit root_path
      fill_in 'q', with: 'xbox'
      find('button.search-btn').click

      expect(page).to have_content('Total de anúncios encontrados: 1')
      expect(page).to have_content('Xbox One')
      expect(page).to have_content('R$ 1.000,00')
      expect(page).to have_no_content('Playstation 4')
      expect(page).to have_no_content('R$ 1.200,00')
    end

    scenario 'by description' do
      company = Company.create!(name: 'Company', domain: 'company.com')
      games_category = company.categories.create!(name: 'Games')
      eletro_category = company.categories.create!(name: 'Eletrodomésticos')
      user = User.create!(name: 'User', social_name: 'User', email: 'user@company.com', password: '123123')
      post_play = user.sale_posts.create!(title: 'Playstation 4', description: 'Novo na caixa', category: games_category,
                                          price: 1200)
      post_xbox = user.sale_posts.create!(title: 'Xbox One', description: 'Recondicionado', category: games_category,
                                          price: 1000)
      post_freezer = user.sale_posts.create!(title: 'Freezer', description: 'Freezer recondicionado, semi novo',
                                             category: eletro_category, price: 600)

      login_as user, scope: :user
      visit root_path
      fill_in 'q', with: 'recondicionado'
      find('button.search-btn').click

      expect(page).to have_content('Total de anúncios encontrados: 2')
      expect(page).to have_content('Xbox One')
      expect(page).to have_content('R$ 1.000,00')
      expect(page).to have_content('Freezer')
      expect(page).to have_content('R$ 600,00')
      expect(page).to have_no_content('Playstation 4')
      expect(page).to have_no_content('R$ 1.200,00')
    end
  end
end
