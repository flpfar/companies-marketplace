require 'rails_helper'

feature 'User views profile' do
  scenario 'must be logged in' do
    Company.create!(name: 'ABC', domain: 'abc.com')
    user = User.create!(name: 'User', email: 'user@abc.com', password: '123123')

    visit profile_user_path(user)

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(page).to have_no_content(user.name)
  end

  scenario 'successfully' do
    company = Company.create!(name: 'ABC', domain: 'abc.com')
    games = company.categories.create!(name: 'Games')
    user = User.create!(name: 'User', email: 'user@abc.com', password: '123123', birth_date: '12/12/1212',
                        department: 'Technology', role: 'Chief')
    xbox_post = user.sale_posts.create!(title: 'Xbox 360', description: 'Really new', price: 500, category: games)
    ps2_post = user.sale_posts.create!(title: 'Playstation 2', description: 'Good one', price: 100, category: games)
    guest = User.create!(email: 'guest@abc.com', password: '123123')

    login_as guest, scope: :user
    visit root_path
    find(".post-item[data-item='#{xbox_post.id}']").click
    within '.post-author' do
      click_on user.name
    end

    expect(current_path).to eq("/users/#{user.id}/profile")
    within '.user-info' do
      expect(page).to have_content('Informações do usuário')
      expect(page).to have_content('Nome')
      expect(page).to have_content(user.name)
      expect(page).to have_content('Data de nascimento')
      expect(page).to have_content(user.birth_date)
      expect(page).to have_content('Setor')
      expect(page).to have_content(user.department)
      expect(page).to have_content('Cargo')
      expect(page).to have_content(user.role)
    end
    within '.sale-posts' do
      expect(page).to have_content(xbox_post.title)
      expect(page).to have_content("R$ #{xbox_post.price},00")
      expect(page).to have_content(ps2_post.title)
      expect(page).to have_content("R$ #{ps2_post.price},00")
    end
  end

  scenario 'and see only enabled posts from user' do
    company = Company.create!(name: 'ABC', domain: 'abc.com')
    games = company.categories.create!(name: 'Games')
    user = User.create!(name: 'User', email: 'user@abc.com', password: '123123')
    xbox_post = user.sale_posts.create!(title: 'Xbox 360', description: 'Really new', price: 500, category: games)
    ps2_post = user.sale_posts.create!(title: 'Playstation 2', price: 100, category: games, status: :disabled,
                                       description: 'Good one')
    ps4_post = user.sale_posts.create!(title: 'Playstation 4', price: 900, category: games, status: :disabled,
                                       description: 'With 2 games')
    guest = User.create!(email: 'guest@abc.com', password: '123123')

    login_as guest, scope: :user
    visit root_path
    find(".post-item[data-item='#{xbox_post.id}']").click
    within '.post-author' do
      click_on user.name
    end

    within '.sale-posts' do
      expect(page).to have_content(xbox_post.title)
      expect(page).to have_content("R$ #{xbox_post.price},00")
      expect(page).to have_no_content(ps2_post.title)
      expect(page).to have_no_content("R$ #{ps2_post.price},00")
      expect(page).to have_no_content(ps4_post.title)
      expect(page).to have_no_content("R$ #{ps4_post.price},00")
    end
  end
end
