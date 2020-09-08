require 'rails_helper'

feature 'User views history' do
  scenario 'successfully' do
    company = Company.create!(name: 'Abc', domain: 'abc.com')
    games = company.categories.create!(name: 'Games')
    kitchen = company.categories.create!(name: 'Kitchen')
    user = User.create!(name: 'User', email: 'user@abc.com', password: '123123')
    other_user = User.create!(name: 'Other User', email: 'otheruser@abc.com', password: '123123')
    xbox = user.sale_posts.create!(title: 'Xbox One', description: 'With 4 games', price: 900, category: games)
    xbox_order = xbox.orders.create!(item_name: xbox.title, item_description: xbox.description,
                                     posted_price: xbox.price, seller: user, buyer: other_user, status: :completed)
    ps4 = user.sale_posts.create!(title: 'Playstation 4', description: 'Brand new', price: 1200, category: games)
    ps4_order = ps4.orders.create!(item_name: ps4.title, item_description: ps4.description,
                                   posted_price: ps4.price, seller: user, buyer: other_user, status: :canceled)
    snes = user.sale_posts.create!(title: 'Super Nintendo', description: 'With box', price: 300, category: games)
    snes_order = snes.orders.create!(item_name: snes.title, item_description: snes.description,
                                     posted_price: snes.price, seller: user, buyer: other_user, status: :in_progress)
    oven = other_user.sale_posts.create!(title: 'New Oven', description: 'Working nice', price: 400, category: kitchen)
    oven_order = oven.orders.create!(item_name: oven.title, item_description: oven.description,
                                     posted_price: oven.price, seller: other_user, buyer: user, status: :completed)

    login_as user, scope: :user
    visit root_path
    click_on user.name
    click_on 'Meu histórico'

    within '.sale-orders' do
      expect(page).to have_content('Histórico de vendas')
      expect(page).to have_content(xbox_order.item_name)
      expect(page).to have_content(ps4_order.item_name)
      expect(page).to have_content(xbox_order.buyer.name, count: 2)
      expect(page).to have_no_content(snes_order.item_name)
    end
    within '.buy-orders' do
      expect(page).to have_content('Histórico de compras')
      expect(page).to have_no_content(xbox_order.item_name)
      expect(page).to have_no_content(ps4_order.item_name)
      expect(page).to have_no_content(snes_order.item_name)
      expect(page).to have_content(oven_order.item_name)
      expect(page).to have_content(xbox_order.seller.name)
    end
  end
end
