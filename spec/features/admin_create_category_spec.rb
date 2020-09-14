require 'rails_helper'

feature 'Admin creates category' do
  scenario 'must be admin' do
    company = Company.create!(name: 'Company', domain: 'company.com')
    user = User.create!(name: 'User', email: 'user@company.com', password: '123123')

    login_as user, scope: :user
    visit dashboard_company_path(company)

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Acesso negado')
  end

  scenario 'successfully' do
    company = Company.create!(name: 'Admin Company', domain: 'admin.com')
    admin = User.create!(name: 'Admin', email: 'admin@admin.com', password: '123123', admin: true)

    login_as admin, scope: :user
    visit dashboard_path
    click_on 'Admin Company'
    fill_in 'Nome', with: 'Games'
    click_on 'Enviar'

    expect(company.categories.last.name).to eq('Games')
    expect(page).to have_content('Categoria criada com sucesso')
  end

  scenario 'with blank name' do
    company = Company.create!(name: 'Admin Company', domain: 'admin.com')
    admin = User.create!(name: 'Admin', email: 'admin@admin.com', password: '123123', admin: true)

    login_as admin, scope: :user
    visit dashboard_path
    click_on 'Admin Company'
    click_on 'Enviar'

    expect(company.categories).to be_empty
    expect(current_path).to eq(dashboard_company_path(company))
    expect(page).to have_content('Falha ao criar categoria')
  end
end
