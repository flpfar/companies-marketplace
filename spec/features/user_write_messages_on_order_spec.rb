require 'rails_helper'

feature 'User writes messages on order' do
  scenario 'successfully' do
    company = Company.create!(name: 'ABC', domain: 'abc.com')
    games = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', email: 'seller@abc.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@abc.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Playstation 4', description: 'Good as new', price: 900, category: games)
    order = post.orders.create!(item_name: post.title, item_description: post.description, posted_price: post.price,
                                buyer: buyer, seller: seller)

    login_as buyer, scope: :user
    visit order_path(order.id)
    within '.messages-container' do
      fill_in 'message_body', with: 'Can you send me the product today?'
      click_on 'Enviar'
    end

    expect(page).to have_content('Mensagem enviada com sucesso')
    within '.messages-container' do
      expect(page).to have_content('Buyer')
      expect(page).to have_content('Can you send me the product today?')
    end
  end

  scenario 'and message is empty' do
    company = Company.create!(name: 'ABC', domain: 'abc.com')
    games = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', email: 'seller@abc.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@abc.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Playstation 4', description: 'Good as new', price: 900, category: games)
    order = post.orders.create!(item_name: post.title, item_description: post.description, posted_price: post.price,
                                buyer: buyer, seller: seller)

    login_as buyer, scope: :user
    visit order_path(order.id)
    within '.messages-container' do
      click_on 'Enviar'
    end

    expect(page).to have_content('Mensagem deve conter texto')
    expect(page).to have_no_content('Mensagem enviada com sucesso')
    within '.messages-container' do
      expect(page).to have_no_content('Buyer')
    end
  end

  scenario 'is not available if order is completed' do
    company = Company.create!(name: 'ABC', domain: 'abc.com')
    games = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', email: 'seller@abc.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@abc.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Playstation 4', description: 'Good as new', price: 900, category: games)
    order = post.orders.create!(item_name: post.title, item_description: post.description, posted_price: post.price,
                                buyer: buyer, seller: seller, status: :completed)

    login_as buyer, scope: :user
    visit order_path(order.id)

    expect(page).to have_no_css('.messages-container')
  end
end
