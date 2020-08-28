require 'rails_helper'

feature 'user sign up' do
  scenario 'successfully' do
    visit root_path
    click_on 'Criar uma conta'
    fill_in 'Email', with: 'joao@coke.com.br'
    fill_in 'Senha', with: '123123'
    fill_in 'Confirme sua senha', with: '123123'
    click_on 'Criar conta'

    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso')
  end

  scenario 'doesnt fill password confirmation' do
    visit root_path
    click_on 'Criar uma conta'
    fill_in 'Email', with: 'joao@coke.com.br'
    fill_in 'Senha', with: '123123'
    click_on 'Criar conta'

    expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
    expect(page).to have_content('Confirme sua senha não é igual a Senha')
  end

  scenario 'email account is already in use' do
    User.create!(email: 'joao@coke.com.br', password: '123456')

    visit root_path
    click_on 'Criar uma conta'
    fill_in 'Email', with: 'joao@coke.com.br'
    fill_in 'Senha', with: '123123'
    fill_in 'Confirme sua senha', with: '123123'
    click_on 'Criar conta'

    expect(page).not_to have_content('Bem vindo! Você realizou seu registro com sucesso')
    expect(page).to have_content('já está em uso')
  end
end
