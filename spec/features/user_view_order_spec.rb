require 'rails_helper'

feature 'User views order' do
  scenario 'must be buyer or seller' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    user_seller = User.create!(name: 'Bruno', email: 'bruno@coke.com', password: '123123')
    user_buyer = User.create!(name: 'Joao', email: 'joao@coke.com', password: '123123')
    category = Category.create!(name: 'Eletrodomésticos', company: company)
    post = SalePost.create!(title: 'Fogão novo', description: 'Em ótimo estado', price: 140,
                            category: category, user: user_seller)
    order = Order.create!(item_name: post.title, item_description: post.description, sale_post: post,
                          posted_price: post.price, status: :in_progress, buyer: user_buyer)
    other_user = User.create!(name: 'Other', email: 'other@coke.com', password: '123123')

    login_as other_user, scope: :user
    visit order_path(order)

    expect(current_path).not_to eq(order_path(order))
    expect(page).not_to have_content('Em andamento')
  end

  context 'as a seller' do
    scenario 'and has option to complete or cancel an order in progress' do
      company = Company.create!(name: 'Coke', domain: 'coke.com')
      user_seller = User.create!(name: 'Bruno', email: 'bruno@coke.com', password: '123123')
      user_buyer = User.create!(name: 'Joao', email: 'joao@coke.com', password: '123123')
      category = Category.create!(name: 'Eletrodomésticos', company: company)
      post = SalePost.create!(title: 'Fogão novo', description: 'Em ótimo estado', price: 140,
                              category: category, user: user_seller)
      order = Order.create!(item_name: post.title, item_description: post.description, sale_post: post,
                            posted_price: post.price, buyer: user_buyer)

      login_as user_seller, scope: :user
      visit order_path(order)

      expect(page).to have_css('.seller-controllers')
      within '.seller-controllers' do
        expect(page).to have_button('Concluir venda')
        expect(page).to have_link('Cancelar venda')
      end
    end

    scenario 'and has no option to complete or cancel a finalized order' do
      company = Company.create!(name: 'Coke', domain: 'coke.com')
      user_seller = User.create!(name: 'Bruno', email: 'bruno@coke.com', password: '123123')
      user_buyer = User.create!(name: 'Joao', email: 'joao@coke.com', password: '123123')
      category = Category.create!(name: 'Eletrodomésticos', company: company)
      post = SalePost.create!(title: 'Fogão novo', description: 'Em ótimo estado', price: 140,
                              category: category, user: user_seller)
      order = Order.create!(item_name: post.title, item_description: post.description, sale_post: post,
                            posted_price: post.price, buyer: user_buyer, status: :completed)

      login_as user_seller, scope: :user
      visit order_path(order)

      expect(page).to have_no_css('.seller-controllers')
      expect(page).to have_no_button('Concluir venda')
      expect(page).to have_no_link('Cancelar venda')
    end
  end
  context 'as a buyer' do
    scenario 'and has no options to control the order' do
      company = Company.create!(name: 'Coke', domain: 'coke.com')
      user_seller = User.create!(name: 'Bruno', email: 'bruno@coke.com', password: '123123')
      user_buyer = User.create!(name: 'Joao', email: 'joao@coke.com', password: '123123')
      category = Category.create!(name: 'Eletrodomésticos', company: company)
      post = SalePost.create!(title: 'Fogão novo', description: 'Em ótimo estado', price: 140,
                              category: category, user: user_seller)
      order = Order.create!(item_name: post.title, item_description: post.description, sale_post: post,
                            posted_price: post.price, buyer: user_buyer)

      login_as user_buyer, scope: :user
      visit order_path(order)

      expect(page).to have_no_css('.seller-controllers')
      expect(page).to have_no_link('Concluir venda')
      expect(page).to have_no_link('Cancelar venda')
    end
  end
end
