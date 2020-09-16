require 'rails_helper'

feature 'User deletes sale_post' do
  scenario 'successfully' do
    company = Company.create!(name: 'Coshop', domain: 'coshop.com')
    category = company.categories.create!(name: 'Informática')
    company.categories.create!(name: 'Games')
    user = User.create!(name: 'User', email: 'user@coshop.com', password: '123123')
    post = user.sale_posts.create!(title: 'Xbox One', description: 'Muito bom', price: 700, category: category)

    login_as user, scope: :user
    visit sale_post_path(post)
    within '.seller-controllers' do
      click_on 'Excluir'
    end

    expect(page).to have_content('Anúncio excluído com sucesso')
    expect(user.sale_posts.reload).to be_empty
  end

  scenario 'and it has orders' do
    company = Company.create!(name: 'Coshop', domain: 'coshop.com')
    category = company.categories.create!(name: 'Informática')
    company.categories.create!(name: 'Games')
    user = User.create!(name: 'User', email: 'user@coshop.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@coshop.com', password: '123123')
    post = user.sale_posts.create!(title: 'Xbox One', description: 'Muito bom', price: 700, category: category)
    post.orders.create!(item_name: post.title, item_description: post.description, posted_price: post.price,
                        buyer: buyer)

    login_as user, scope: :user
    visit sale_post_path(post)
    within '.seller-controllers' do
      click_on 'Excluir'
    end

    expect(page).to have_no_content('Anúncio excluído com sucesso')
    expect(page).to have_content('Falha ao excluir anúncio. '\
                                 'Este anúncio possui pedidos de compra')
    expect(user.sale_posts.reload).not_to be_empty
  end
end
