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
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit root_path
    within '.user-menu' do
      click_on 'Criar um anúncio'
    end
    fill_in 'Título', with: 'Fogão'
    select 'Eletrodomésticos', from: 'Categoria'
    fill_in 'Descrição', with: 'Fogão ideal para todos'
    fill_in 'Preço', with: '300'
    attach_file 'Imagem de capa', Rails.root.join('spec/support/test-image.jpg')
    click_on 'Criar anúncio'

    expect(page).to have_content('Anúncio criado com sucesso')
    within '.post-container' do
      expect(page).to have_content('Fogão')
      expect(page).to have_content('Eletrodomésticos')
      expect(page).to have_content('Fogão ideal para todos')
      expect(page).to have_content('R$ 300,00')
      expect(page).to have_css('img[src*="test-image.jpg"]')
      expect(page).to have_content(user_diego.name)
    end
  end

  scenario 'and see only categories from company' do
    company_coke = Company.create!(name: 'Coke', domain: 'coke.com.br')
    company_pepsi = Company.create!(name: 'Coke', domain: 'pepsi.com.br')
    Category.create!(name: 'Eletrodomésticos', company: company_coke)
    Category.create!(name: 'Smartphones', company: company_coke)
    Category.create!(name: 'Móveis', company: company_pepsi)
    Category.create!(name: 'Automóveis', company: company_pepsi)
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit new_sale_post_path

    expect(page).to have_select('Categoria', options: ['Escolha uma categoria', 'Eletrodomésticos', 'Smartphones'])
  end

  scenario 'and attributes cant be blank' do
    company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    Category.create!(name: 'Eletrodomésticos', company: company)
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit root_path
    within '.user-menu' do
      click_on 'Criar um anúncio'
    end
    click_on 'Criar anúncio'

    expect(page).to have_content('Categoria é obrigatório(a)')
    expect(page).to have_content('não pode ficar em branco', count: 3)
    expect(SalePost.count).to eq(0)
  end

  scenario 'and is redirected to root when no categories were created' do
    Company.create!(name: 'Coke', domain: 'coke.com.br')
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit new_sale_post_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Não há categorias cadastradas na sua empresa. Contate o administrador')
  end
end
