require 'rails_helper'

feature 'User logs in' do
  scenario 'successfully' do
    Company.create!(name: 'Coke', domain: 'coke.com')
    User.create!(email: 'user@coke.com', password: '123123')

    visit root_path
    fill_in 'Email', with: 'user@coke.com'
    fill_in 'Senha', with: '123123'
    click_on 'Entrar'

    expect(page).to have_content('user@coke.com')
    expect(page).to have_link('Sair', href: destroy_user_session_path)
    expect(current_path).to eq(root_path)
    expect(page).not_to have_content('Para continuar, faça login ou registre-se')
    expect(page).not_to have_content('Email ou senha inválidos')
  end

  scenario 'and logs out' do
    Company.create!(name: 'Coke', domain: 'coke.com')
    User.create!(email: 'user@coke.com', password: '123123')

    visit root_path
    fill_in 'Email', with: 'user@coke.com'
    fill_in 'Senha', with: '123123'
    click_on 'Entrar'
    within '.user-menu' do
      click_on 'Sair'
    end

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'with wrong email' do
    Company.create!(name: 'Coke', domain: 'coke.com')
    User.create!(email: 'user@coke.com', password: '123123')

    visit root_path
    fill_in 'Email', with: 'usera@coke.com'
    fill_in 'Senha', with: '123123'
    click_on 'Entrar'

    expect(page).not_to have_content('user@coke.com')
    expect(page).not_to have_content('usera@coke.com')
    expect(page).not_to have_link('Sair', href: destroy_user_session_path)
    expect(page).not_to have_content('Para continuar, faça login ou registre-se')
    expect(page).to have_content('Email ou senha inválidos')
  end

  scenario 'with wrong password' do
    Company.create!(name: 'Coke', domain: 'coke.com')
    User.create!(email: 'user@coke.com', password: '123123')

    visit root_path
    fill_in 'Email', with: 'user@coke.com'
    fill_in 'Senha', with: '111111'
    click_on 'Entrar'

    expect(page).not_to have_content('user@coke.com')
    expect(page).not_to have_link('Sair', href: destroy_user_session_path)
    expect(page).to have_content('Email ou senha inválidos')
  end
end
