require 'rails_helper'

feature 'User edits sale post' do
  scenario 'must be the author' do
    company = Company.create!(name: 'Coshop', domain: 'coshop.com')
    category = company.categories.create!(name: 'Informática')
    user = User.create!(name: 'User', email: 'user@coshop.com', password: '123123')
    author = User.create!(name: 'Post Author', email: 'author@coshop.com', password: '123123')
    post = author.sale_posts.create!(title: 'Xbox One', description: 'Muito bom', price: 700, category: category)

    login_as user, scope: :user
    visit edit_sale_post_path(post)

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Acesso negado')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Coshop', domain: 'coshop.com')
    category = company.categories.create!(name: 'Informática')
    company.categories.create!(name: 'Games')
    user = User.create!(name: 'User', email: 'user@coshop.com', password: '123123')
    post = user.sale_posts.create!(title: 'Xbox One', description: 'Muito bom', price: 700, category: category)

    login_as user, scope: :user
    visit sale_post_path(post)
    within '.seller-controllers' do
      click_on 'Editar'
    end
    fill_in 'Título', with: 'Xbox 360'
    fill_in 'Descrição', with: 'Semi novo'
    fill_in 'Preço', with: 300
    select 'Games', from: 'Categoria'
    click_on 'Atualizar anúncio'

    expect(page).to have_content('Anúncio atualizado com sucesso')
    expect(current_path).to eq(sale_post_path(post))
    within '.post-container' do
      expect(page).to have_content('Xbox 360')
      expect(page).to have_content('Semi novo')
      expect(page).to have_content('Games')
      expect(page).to have_content('300')
      expect(page).to have_no_content('Xbox One')
      expect(page).to have_no_content('Muito bom')
      expect(page).to have_no_content('Informática')
      expect(page).to have_no_content('700')
    end
  end
end
