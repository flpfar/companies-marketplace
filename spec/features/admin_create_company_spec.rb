require 'rails_helper'

feature 'Admin creates company' do
  scenario 'must be admin' do
  end

  scenario 'successfully' do
    admin = Admin.create!(name: 'Admin', email: 'admin@admin.com', password: '123123')

    login_as admin, scope: :admin
    visit dashboard_path
    click_on 'Adicionar empresa'
    fill_in 'Nome', with: 'Company'
    fill_in 'Domínio', with: 'company.com'
    click_on 'Enviar'

    expect(Company.last.name).to eq('Company')
    expect(Company.last.domain).to eq('company.com')
  end

  scenario 'without a name' do
    admin = Admin.create!(name: 'Admin', email: 'admin@admin.com', password: '123123')

    login_as admin, scope: :admin
    visit dashboard_path
    click_on 'Adicionar empresa'
    fill_in 'Domínio', with: 'company.com'
    click_on 'Enviar'

    expect(page).to have_content('Falha ao criar empresa')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'with an invalid domain' do
    admin = Admin.create!(name: 'Admin', email: 'admin@admin.com', password: '123123')

    login_as admin, scope: :admin
    visit dashboard_path
    click_on 'Adicionar empresa'
    fill_in 'Nome', with: 'Company'
    fill_in 'Domínio', with: 'companycom'
    click_on 'Enviar'

    expect(page).to have_content('Falha ao criar empresa')
    expect(page).to have_content('Domínio não é válido')
  end
end
