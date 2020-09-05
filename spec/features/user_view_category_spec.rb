require 'rails_helper'

feature 'User views category' do
  scenario 'successfully' do
    company = Company.create!(name: 'Company', domain: 'company.com')
    category_games = Category.create!(name: 'Games', company: company)
    category_eletro = Category.create!(name: 'Eletrodomésticos', company: company)
    user = User.create!(name: 'User', email: 'user@company.com', password: '123123')
    xbox = SalePost.create!(user: user, category: category_games, title: 'XBox one', description: 'With 5 games',
                            price: 900)
    freezer = SalePost.create!(user: user, category: category_eletro, title: 'Freezer', description: 'Really new',
                               price: 500)

    login_as user, scope: :user
    visit root_path
    within 'nav' do
      click_on 'Categorias'
    end
    within '.categories-list' do
      click_on 'Games'
    end

    expect(page).to have_content(xbox.title)
    expect(page).to have_content("R$ #{xbox.price},00")
    expect(page).to have_content("Total de anúncios em Games: #{category_games.sale_posts.size}")
    expect(page).to have_no_content(freezer.title)
  end

  scenario 'and cant see disabled sale posts' do
    company = Company.create!(name: 'Company', domain: 'company.com')
    category_games = Category.create!(name: 'Games', company: company)
    category_eletro = Category.create!(name: 'Eletrodomésticos', company: company)
    user = User.create!(name: 'User', email: 'user@company.com', password: '123123')
    xbox = SalePost.create!(user: user, category: category_games, title: 'Xbox One', description: 'With 5 games',
                            price: 900)
    ps4 = SalePost.create!(user: user, category: category_games, title: 'Playstation 4', description: 'Really new',
                           price: 1500)
    nintendo = SalePost.create!(user: user, category: category_games, title: 'Super Nintendo', price: 500,
                                description: 'With 10 games', status: :disabled)

    login_as user, scope: :user
    visit root_path
    within 'nav' do
      click_on 'Categorias'
    end
    within '.categories-list' do
      click_on 'Games'
    end

    expect(page).to have_content(xbox.title)
    expect(page).to have_content(ps4.title)
    expect(page).to have_no_content(nintendo.title)
    expect(page).to have_content('Total de anúncios em Games: 2')
  end
end
