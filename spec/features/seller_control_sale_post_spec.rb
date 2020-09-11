require 'rails_helper'

feature 'Seller controls sale post' do
  context 'and disables it' do
    scenario 'successfully' do
      company = Company.create!(name: 'ABC', domain: 'abc.com')
      games = company.categories.create!(name: 'Games')
      seller = User.create!(name: 'Seller', email: 'seller@abc.com', password: '123123')
      post = seller.sale_posts.create!(title: 'xbox one', description: 'brand new', price: 800, category: games)

      login_as seller, scope: :user
      visit root_path
      within '.user-menu' do
        click_on seller.name
      end
      click_on 'Meus anúncios'
      within '.my-posts-container' do
        click_on post.title
      end
      within '.seller-controllers' do
        click_on 'Desativar anúncio'
      end

      expect(page).to have_content('Anúncio desativado com sucesso')
      within '.seller-controllers' do
        expect(page).to have_link('Reativar anúncio')
      end
      expect(current_path).to eq(sale_post_path(post))
    end

    scenario 'only if there are no orders in progress' do
      company = Company.create!(name: 'ABC', domain: 'abc.com')
      games = company.categories.create!(name: 'Games')
      seller = User.create!(name: 'Seller', email: 'seller@abc.com', password: '123123')
      buyer = User.create!(name: 'Buyer', email: 'buyer@abc.com', password: '123123')
      post = seller.sale_posts.create!(title: 'xbox one', description: 'brand new', price: 800, category: games)
      post.orders.create!(item_name: post.title, item_description: post.description, posted_price: post.price,
                          buyer: buyer, seller: seller)

      login_as seller, scope: :user
      visit root_path
      within '.user-menu' do
        click_on seller.name
      end
      click_on 'Meus anúncios'
      within '.my-posts-container' do
        click_on post.title
      end
      within '.seller-controllers' do
        click_on 'Desativar anúncio'
      end

      expect(page).to have_no_content('Anúncio desativado com sucesso')
      expect(page).to have_content('Este anúncio possui pedidos de compra pendentes. '\
                                   'Finalize-os primeiro e tente novamente')
      within '.seller-controllers' do
        expect(page).to have_no_link('Reativar anúncio')
      end
      expect(current_path).to eq(sale_post_path(post))
    end
  end

  context 'and enables it' do
    scenario 'successfully' do
      company = Company.create!(name: 'ABC', domain: 'abc.com')
      games = company.categories.create!(name: 'Games')
      seller = User.create!(name: 'Seller', email: 'seller@abc.com', password: '123123')
      post = seller.sale_posts.create!(
        title: 'xbox one', description: 'brand new', price: 800, category: games, status: :disabled
      )

      login_as seller, scope: :user
      visit root_path
      within '.user-menu' do
        click_on seller.name
      end
      click_on 'Meus anúncios'
      within '.my-posts-container' do
        click_on post.title
      end
      within '.seller-controllers' do
        click_on 'Reativar anúncio'
      end

      expect(page).to have_content('Anúncio reativado com sucesso')
      within '.seller-controllers' do
        expect(page).to have_no_link('Reativar anúncio')
        expect(page).to have_link('Desativar anúncio')
      end
      expect(current_path).to eq(sale_post_path(post))
    end

    scenario 'only if there are no complete orders' do
      company = Company.create!(name: 'ABC', domain: 'abc.com')
      games = company.categories.create!(name: 'Games')
      seller = User.create!(name: 'Seller', email: 'seller@abc.com', password: '123123')
      buyer = User.create!(name: 'Buyer', email: 'buyer@abc.com', password: '123123')
      post = seller.sale_posts.create!(title: 'xbox one', description: 'brand new', price: 800, category: games,
                                       status: :sold)
      post.orders.create!(item_name: post.title, item_description: post.description, posted_price: post.price,
                          buyer: buyer, seller: seller, status: :completed)

      login_as seller, scope: :user
      visit root_path
      within '.user-menu' do
        click_on seller.name
      end
      click_on 'Meus anúncios'
      within '.my-posts-container' do
        click_on post.title
      end

      expect(page).to have_no_css('.seller-controllers')
      expect(page).to have_no_link('Reativar anúncio')
    end
  end
end
