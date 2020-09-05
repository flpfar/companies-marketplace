require 'rails_helper'

feature 'User views notifications' do
  scenario 'successfully' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', social_name: 'Seller', email: 'seller@coke.com', password: '123123')
    buyer = User.create!(name: 'Buyer', social_name: 'Buyer', email: 'buyer@coke.com', password: '123123')
    post1 = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                      category: category)
    post2 = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                      category: category)
    Order.create!(item_name: post1.title, item_description: post1.description, sale_post: post1,
                  posted_price: post1.price, status: :in_progress, buyer: buyer, seller: seller)
    Order.create!(item_name: post2.title, item_description: post2.description, sale_post: post2,
                  posted_price: post2.price, status: :in_progress, buyer: buyer, seller: seller)

    login_as seller, scope: :user
    visit root_path
    click_on seller.social_name

    expect(page).to have_css('.notifications')
    within '.notifications' do
      expect(page).to have_content(2)
    end
    expect(seller.notifications.unseen.size).to eq(2)
    expect(page).to have_content("Solicitação de compra pendente em anúncio #{post1.title}")
    expect(page).to have_content("Solicitação de compra pendente em anúncio #{post2.title}")
  end

  scenario 'and visits notification' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', social_name: 'Seller', email: 'seller@coke.com', password: '123123')
    buyer = User.create!(name: 'Buyer', social_name: 'Buyer', email: 'buyer@coke.com', password: '123123')
    post = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                     category: category)
    Order.create!(item_name: post.title, item_description: post.description, sale_post: post,
                  posted_price: post.price, status: :in_progress, buyer: buyer, seller: seller)

    login_as seller, scope: :user
    visit root_path
    click_on seller.social_name
    click_on seller.notifications.first.body

    expect(page).to have_no_css('.notifications')
    expect(current_path).to eq('/orders/1')
    expect(page).to have_content(post.title)
    expect(page).to have_content('R$ 1.000,00')
    expect(seller.notifications.unseen).to be_empty
    expect(seller.notifications.first).to be_seen
  end

  scenario 'and has none' do
    Company.create!(name: 'Coke', domain: 'coke.com')
    user = User.create!(name: 'User', social_name: 'User', email: 'user@coke.com', password: '123123')

    login_as user, scope: :user
    visit root_path

    expect(page).to have_no_css('.notifications')
  end
end
