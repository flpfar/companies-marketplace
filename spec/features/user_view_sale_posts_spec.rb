require 'rails_helper'

feature 'User views sale posts' do
  scenario 'must be signed in' do
    visit root_path

    expect(current_path).to eq new_user_session_path
  end

  scenario 'sucessfully' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_disabled = User.create!(email: 'maria@coke.com.br', password: '123123')
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    sale_post_refrigerator = SalePost.create!(title: 'Geladeira Brastemp', price: '800', user: user_bruno,
                                              description: 'Geladeira semi nova, em ótimo estado',
                                              category: eletro_category)
    sale_post_fogao = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                                       description: 'Fogão ideal pra todos', category: eletro_category)

    visit root_path
    fill_in 'Email', with: user_disabled.email
    fill_in 'Senha', with: user_disabled.password
    click_on 'Entrar'

    within 'nav' do
      expect(page).to have_content(user_disabled.email)
    end
    within 'div.posts-container' do
      expect(page).to have_content(sale_post_refrigerator.title)
      expect(page).to have_content("R$ #{sale_post_refrigerator.price},00")
      expect(page).to have_content(sale_post_fogao.title)
      expect(page).to have_content("R$ #{sale_post_fogao.price},00")
    end
  end

  scenario 'and no posts were created' do
    Company.create!(name: 'Coke', domain: 'coke.com.br')
    disabled_user = User.create!(email: 'maria@coke.com.br', password: '123123')

    login_as disabled_user
    visit root_path

    within 'div.posts-container' do
      expect(page).to have_content('Não há anúncios cadastrados')
    end
  end

  scenario 'that are enabled only' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_disabled = User.create!(email: 'maria@coke.com.br', password: '123123')
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    sale_post_refrigerator = SalePost.create!(title: 'Geladeira Brastemp', price: '800', user: user_bruno,
                                              description: 'Geladeira semi nova, em ótimo estado',
                                              category: eletro_category, status: :disabled)
    sale_post_fogao = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                                       description: 'Fogão ideal pra todos', category: eletro_category)

    visit root_path
    fill_in 'Email', with: user_disabled.email
    fill_in 'Senha', with: user_disabled.password
    click_on 'Entrar'

    within 'div.posts-container' do
      expect(page).to have_no_content(sale_post_refrigerator.title)
      expect(page).to have_no_content("R$ #{sale_post_refrigerator.price},00")
      expect(page).to have_content(sale_post_fogao.title)
      expect(page).to have_content("R$ #{sale_post_fogao.price},00")
    end
  end

  scenario 'only from the same company' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    pepsi_company = Company.create!(name: 'Pepsi', domain: 'pepsi.com.br')
    eletro_coke_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    eletro_pepsi_category = Category.create!(name: 'Eletrodomésticos', company: pepsi_company)
    furniture_pepsi_category = Category.create!(name: 'Móveis', company: pepsi_company)
    disabled_user = User.create!(email: 'maria@coke.com.br', password: '123123')
    user_bruno = User.create!(name: 'Bruno', email: 'bruno@coke.com.br', password: '123123',
                              role: 'Gerente', department: 'T.I', birth_date: '18/10/90')
    user_diego = User.create!(name: 'Diego', email: 'diego@pepsi.com.br', password: '123123',
                              role: 'Auxiliar', department: 'Comercial', birth_date: '18/10/90')
    sale_post_refrigerator = SalePost.create!(title: 'Geladeira Brastemp', price: '800', user: user_bruno,
                                              description: 'Geladeira semi nova, em ótimo estado',
                                              category: eletro_coke_category)
    sale_post_fogao = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_diego,
                                       description: 'Fogão ideal pra todos', category: eletro_pepsi_category)
    sale_post_sofa = SalePost.create!(title: 'Sofá', price: '100', user: user_diego,
                                      description: 'Sofá de 3 lugares', category: furniture_pepsi_category)

    login_as disabled_user, scope: :user
    visit root_path

    within 'div.posts-container' do
      expect(page).to have_content(sale_post_refrigerator.title)
      expect(page).to have_content("R$ #{sale_post_refrigerator.price},00")
      expect(page).not_to have_content(sale_post_fogao.title)
      expect(page).not_to have_content("R$ #{sale_post_fogao.price},00")
      expect(page).not_to have_content(sale_post_sofa.title)
      expect(page).not_to have_content("R$ #{sale_post_sofa.price},00")
    end
  end

  scenario 'from different users' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    furniture_category = Category.create!(name: 'Móveis', company: coke_company)
    disabled_user = User.create!(email: 'maria@coke.com.br', password: '123123')
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90',
                              role: 'Gerente', department: 'T.I',
                              email: 'bruno@coke.com.br', password: '123123')
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')
    sale_post_geladeira = SalePost.create!(title: 'Geladeira Brastemp', price: '800', user: user_bruno,
                                           description: 'Geladeira semi nova, em ótimo estado',
                                           category: eletro_category)
    sale_post_fogao = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_diego,
                                       description: 'Fogão ideal pra todos', category: eletro_category)
    sale_post_sofa = SalePost.create!(title: 'Sofá', price: '100', user: user_diego,
                                      description: 'Sofá de 3 lugares', category: furniture_category)

    login_as disabled_user, scope: :user
    visit root_path

    within 'div.posts-container' do
      expect(page).to have_content(sale_post_geladeira.title)
      expect(page).to have_content("R$ #{sale_post_geladeira.price},00")
      expect(page).to have_content(sale_post_fogao.title)
      expect(page).to have_content("R$ #{sale_post_fogao.price},00")
      expect(page).to have_content(sale_post_sofa.title)
      expect(page).to have_content("R$ #{sale_post_sofa.price},00")
    end
  end
end
