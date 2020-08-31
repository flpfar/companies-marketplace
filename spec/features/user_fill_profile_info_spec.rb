require 'rails_helper'

feature 'user fill profile info' do
  scenario 'successfully' do
    Company.create!(name: 'Coke', domain: 'coke.com.br')
    user = User.create!(email: 'maria@coke.com.br', password: '123123')

    login_as user, scope: :user
    visit root_path
    click_on 'Preencher perfil'
    fill_in 'Nome', with: 'Maria Antônia'
    fill_in 'Nome social', with: 'Toninha'
    fill_in 'Data de nascimento', with: '01/01/1991'
    fill_in 'Cargo', with: 'Gerente'
    fill_in 'Setor', with: 'Vendas'
    click_on 'Enviar'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('A sua conta foi atualizada com sucesso')
    expect(page).to have_content('Toninha')
  end

  scenario 'and fields can not be empty' do
    Company.create!(name: 'Coke', domain: 'coke.com.br')
    user = User.create!(email: 'maria@coke.com.br', password: '123123')

    login_as user, scope: :user
    visit root_path
    click_on 'Preencher perfil'
    click_on 'Enviar'

    expect(page).to have_content('não pode ficar em branco', count: 5)
  end

  scenario 'and is able to see a link to publish a product for sale' do
    Company.create!(name: 'Coke', domain: 'coke.com.br')
    user = User.create!(email: 'maria@coke.com.br', password: '123123')

    login_as user, scope: :user
    visit root_path
    click_on 'Preencher perfil'
    fill_in 'Nome', with: 'Maria Antônia'
    fill_in 'Nome social', with: 'Toninha'
    fill_in 'Data de nascimento', with: '01/01/1991'
    fill_in 'Cargo', with: 'Gerente'
    fill_in 'Setor', with: 'Vendas'
    click_on 'Enviar'
    user.reload

    expect(page).to have_content('Criar um anúncio')
    expect(user).to be_enabled
  end

  scenario 'and is not able to see a link to publish a product for sale if profile info fails' do
    Company.create!(name: 'Coke', domain: 'coke.com.br')
    user = User.create!(email: 'maria@coke.com.br', password: '123123')

    login_as user, scope: :user
    visit root_path
    click_on 'Preencher perfil'
    click_on 'Enviar'
    user.reload

    expect(page).not_to have_content('Criar um anúncio')
    expect(user).not_to be_enabled
  end
end
