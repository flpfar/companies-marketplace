require 'rails_helper'

feature 'User creates sale post' do
  scenario 'must be logged in' do
    visit new_sale_post_path

    expect(current_path).not_to eq(new_sale_post_path)
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(page).not_to have_content('Para criar um anúncio seu perfil deve estar preenchido')
  end

  scenario 'must be an enabled user' do
    Company.create!(name: 'Coke', domain: 'coke.com.br')
    disabled_user = User.create!(email: 'maria@coke.com.br', password: '123123')

    login_as disabled_user, scope: :user
    visit new_sale_post_path

    expect(current_path).not_to eq(new_sale_post_path)
    expect(page).to have_content('Para criar um anúncio seu perfil deve estar preenchido')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    Category.create!(name: 'Eletrodomésticos', company: company)
    Category.create!(name: 'Smartphones', company: company)
    user_diego = User.create!(name: 'Diego', social_name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial', status: 1,
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit root_path
    click_on 'Criar um anúncio'
    fill_in 'Título', with: 'Fogão'
    select 'Eletrodomésticos', from: 'Categoria'
    fill_in 'Descrição', with: 'Fogão ideal para todos'
    fill_in 'Preço', with: '300'
    click_on 'Criar anúncio'

    expect(page).to have_content('Anúncio criado com sucesso')
    within '.post-container' do
      expect(page).to have_content('Fogão')
      expect(page).to have_content('Eletrodomésticos')
      expect(page).to have_content('Fogão ideal para todos')
      expect(page).to have_content('R$ 300,00')
      expect(page).to have_content(user_diego.name)
      expect(page).to have_content(user_diego.email)
      expect(page).to have_content(user_diego.role)
      expect(page).to have_content(user_diego.department)
    end
  end
end
