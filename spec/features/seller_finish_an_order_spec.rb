require 'rails_helper'

feature 'Seller finishes an order' do
  scenario 'with a completed status' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', social_name: 'Seller', email: 'seller@coke.com', password: '123123')
    buyer = User.create!(name: 'Buyer', social_name: 'Buyer', email: 'buyer@coke.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                     category: category)

    login_as buyer, scope: :user
    visit sale_post_path(post)
    click_on 'Comprar'
    click_on 'Sair'
    login_as seller, scope: :user
    visit root_path
    click_on seller.social_name
    click_on seller.notifications.first.body
    click_on 'Concluir venda'

    expect(page).to have_content('Venda finalizada com sucesso')
    expect(current_path).to eq(root_path)
    expect(post.reload).to be_disabled
    expect(post.orders.first).to be_completed
    expect(buyer.reload.notifications.unseen.first.body).to include('O vendedor aceitou seu pedido de compra')
  end
end
