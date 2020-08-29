require 'rails_helper'

feature 'User views sale posts' do
  scenario 'must be signed in' do
    visit root_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('Para continuar, faça login ou registre-se.')
  end

  scenario 'sucessfully' do
    user_disabled = User.create!(email: 'maria@coke.com.br', password: '123123')
    user_bruno = User.create!(name: 'Bruno', social_name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', status: 1, email: 'bruno@coke.com.br', password: '123123')
    user_diego = User.create!(name: 'Diego', social_name: 'Diego', birth_date: '18/01/90', role: 'Auxiliar',
                              department: 'Comercial', status: 1, email: 'diego@coke.com.br', password: '123123')
    sale_post_geladeira = SalePost.create!(title: 'Geladeira Brastemp', price: '800', user: user_bruno,
                                           description: 'Geladeira semi nova, em ótimo estado')
    sale_post_fogao = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_diego,
                                       description: 'Fogão ideal pra todos')

    visit root_path
    fill_in 'Email', with: user_disabled.email
    fill_in 'Senha', with: user_disabled.password
    click_on 'Log in'

    within 'nav' do
      expect(page).to have_content(user_disabled.email)
    end
    within 'div.posts-container' do
      expect(page).to have_content(sale_post_geladeira.title)
      expect(page).to have_content("R$ #{sale_post_geladeira.price},00")
      expect(page).to have_content(sale_post_fogao.title)
      expect(page).to have_content("R$ #{sale_post_fogao.price},00")
    end
  end

  scenario 'and no posts were created' do
    disabled_user = User.create!(email: 'maria@coke.com.br', password: '123123')

    login_as disabled_user
    visit root_path

    within 'div.posts-container' do
      expect(page).to have_content('Não há anúncios cadastrados')
    end
  end
end
