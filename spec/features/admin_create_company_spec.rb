require 'rails_helper'

feature 'Admin creates company' do
  scenario 'must be admin' do
    Company.create!(name: 'Company', domain: 'company.com')
    user = User.create!(name: 'User', email: 'user@company.com', password: '123123')

    login_as user, scope: :user
    visit new_dashboard_company_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Acesso negado')
  end

  scenario 'successfully' do
    Company.create!(name: 'Admin Company', domain: 'admin.com')
    admin = User.create!(name: 'Admin', email: 'admin@admin.com', password: '123123', admin: true)

    login_as admin, scope: :user
    visit dashboard_path
    click_on 'Adicionar empresa'
    fill_in 'Nome', with: 'Company'
    fill_in 'Domínio', with: 'company.com'
    click_on 'Enviar'

    expect(Company.last.name).to eq('Company')
    expect(Company.last.domain).to eq('company.com')
  end

  scenario 'without a name' do
    Company.create!(name: 'Admin Company', domain: 'admin.com')
    admin = User.create!(name: 'Admin', email: 'admin@admin.com', password: '123123', admin: true)

    login_as admin, scope: :user
    visit dashboard_path
    click_on 'Adicionar empresa'
    fill_in 'Domínio', with: 'company.com'
    click_on 'Enviar'

    expect(page).to have_content('Falha ao criar empresa')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'with an invalid domain' do
    Company.create!(name: 'Admin Company', domain: 'admin.com')
    admin = User.create!(name: 'Admin', email: 'admin@admin.com', password: '123123', admin: true)

    login_as admin, scope: :user
    visit dashboard_path
    click_on 'Adicionar empresa'
    fill_in 'Nome', with: 'Company'
    fill_in 'Domínio', with: 'companycom'
    click_on 'Enviar'

    expect(page).to have_content('Falha ao criar empresa')
    expect(page).to have_content('Domínio não é válido')
  end
end
