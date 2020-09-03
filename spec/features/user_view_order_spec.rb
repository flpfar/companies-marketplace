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
                          posted_price: post.price, status: :in_progress, buyer: user_buyer, seller: user_seller)
    other_user = User.create!(name: 'Other', email: 'other@coke.com', password: '123123')

    login_as other_user, scope: :user
    visit order_path(order)

    expect(current_path).not_to eq(order_path(order))
    expect(page).not_to have_content('Em andamento')
  end

  xcontext 'as a seller'
  xscenario 'has option to complete or cancel an order in progress'
  xcontext 'as a buyer'
  xscenario 'has no options to control the order'
  xscenario 'can see messages'
end
