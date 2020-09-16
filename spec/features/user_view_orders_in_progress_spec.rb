require 'rails_helper'

feature 'User views orders in progress' do
  scenario 'successfully' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    user = User.create!(name: 'User', email: 'user@coke.com', password: '123123')
    lorem = User.create!(name: 'Lorem', email: 'lorem@coke.com', password: '123123')
    post1 = user.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                    category: category)
    post2 = user.sale_posts.create!(title: 'Play 4', price: 1200, description: 'Alguma descrição',
                                    category: category)
    post3 = lorem.sale_posts.create!(title: 'Super nintendo', price: 200, description: 'Outra descrição',
                                     category: category)
    Order.create!(item_name: post1.title, item_description: post1.description, sale_post: post1,
                  posted_price: post1.price, status: :in_progress, buyer: lorem)
    Order.create!(item_name: post2.title, item_description: post2.description, sale_post: post2,
                  posted_price: post2.price, status: :completed, buyer: lorem)
    Order.create!(item_name: post3.title, item_description: post3.description, sale_post: post3,
                  posted_price: post3.price, status: :in_progress, buyer: user)

    login_as user, scope: :user
    visit root_path
    within '.user-menu' do
      click_on user.name
    end

    within '.my-orders-in-progress' do
      expect(page).to have_content('Xbox One')
      expect(page).to have_content('Super nintendo')
      expect(page).to have_content('Lorem', count: 2)
    end
  end
end
