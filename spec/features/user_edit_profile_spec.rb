require 'rails_helper'

feature 'User edits profile' do
  scenario 'successfully' do
    Company.create!(name: 'Coshop', domain: 'coshop.com')
    lorem = User.create!(name: 'Lorem', birth_date: '01/01/1991', role: 'Gerente', department: 'Vendas',
                         email: 'lorem@coshop.com', password: '123123')

    login_as lorem, scope: :user
    visit root_path
    within '.user-menu' do
      click_on lorem.name
    end
    click_on 'Meu perfil'
    click_on 'Editar perfil'
    fill_in 'Nome', with: 'Lorem Ipsum'
    fill_in 'Data de nascimento', with: '02/02/1992'
    fill_in 'Cargo', with: 'Gerente Geral'
    fill_in 'Setor', with: 'Marketing'
    click_on 'Enviar'
    lorem.reload

    expect(current_path).to eq(root_path)
    expect(page).to have_content('A sua conta foi atualizada com sucesso')
    expect(page).to have_content('Lorem Ipsum')
    expect(lorem.birth_date).to eq(Date.parse('02/02/1992'))
    expect(lorem.role).to eq('Gerente Geral')
    expect(lorem.department).to eq('Marketing')
  end

  scenario 'is only available for current user' do
    Company.create!(name: 'Coshop', domain: 'coshop.com')
    lorem = User.create!(name: 'Lorem', birth_date: '01/01/1991', role: 'Gerente', department: 'Vendas',
                         email: 'lorem@coshop.com', password: '123123')
    other = User.create!(name: 'Other', birth_date: '02/02/1991', role: 'Auxiliar', department: 'Vendas',
                         email: 'other@coshop.com', password: '123123')

    login_as other, scope: :user
    visit profile_user_path(lorem)

    expect(page).to have_no_link('Editar perfil')
  end
end
