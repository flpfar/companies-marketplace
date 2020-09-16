require 'rails_helper'

feature 'Seller finishes an order' do
  scenario 'with a completed status' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', email: 'seller@coke.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@coke.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                     category: category)

    login_as buyer, scope: :user
    visit sale_post_path(post)
    click_on 'Comprar'
    within '.user-menu' do
      click_on 'Sair'
    end
    login_as seller, scope: :user
    visit root_path
    within '.user-menu' do
      click_on seller.name
    end
    click_on seller.notifications.first.body
    click_on 'Concluir venda'
    fill_in 'Valor final', with: 1020
    click_on 'Finalizar'

    expect(page).to have_content('Venda finalizada com sucesso')
    expect(current_path).to eq('/orders/1')
    expect(page).to have_content('Finalizado')
    expect(page).to have_content('R$ 1.020,00')
    expect(post.reload).to be_sold
    expect(post.orders.first).to be_completed
    expect(buyer.reload.notifications.unseen.first.body).to include('O vendedor aceitou seu pedido de compra')
  end

  scenario 'with a completed without filling the final price' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', email: 'seller@coke.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@coke.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                     category: category)

    login_as buyer, scope: :user
    visit sale_post_path(post)
    click_on 'Comprar'
    within '.user-menu' do
      click_on 'Sair'
    end
    login_as seller, scope: :user
    visit root_path
    within '.user-menu' do
      click_on seller.name
    end
    click_on seller.notifications.first.body
    click_on 'Concluir venda'
    click_on 'Finalizar'

    expect(page).to have_content('Venda finalizada com sucesso')
    expect(current_path).to eq('/orders/1')
    expect(page).to have_content('Finalizado')
    expect(page).to have_content('R$ 1.000,00', count: 2)
    expect(post.reload).to be_sold
    expect(post.orders.first).to be_completed
    expect(buyer.reload.notifications.unseen.first.body).to include('O vendedor aceitou seu pedido de compra')
  end

  scenario 'with a canceled status' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', email: 'seller@coke.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@coke.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                     category: category)
    Order.create!(item_name: post.title, item_description: post.description, sale_post: post,
                  posted_price: post.price, status: :in_progress, buyer: buyer)

    login_as seller, scope: :user
    visit root_path
    within '.user-menu' do
      click_on seller.name
    end
    click_on seller.notifications.first.body
    click_on 'Cancelar venda'

    expect(page).to have_content('Venda cancelada com sucesso')
    expect(current_path).to eq(root_path)
    expect(post.reload).to be_enabled
    expect(post.orders.first).to be_canceled
    expect(buyer.reload.notifications.unseen.first.body).to include('O vendedor cancelou seu pedido de compra')
  end
end
