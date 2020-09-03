require 'rails_helper'

feature 'User buys a product' do
  scenario 'successfully' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_bruno = User.create!(name: 'Bruno', social_name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                            description: 'Fogão ideal pra todos', category: eletro_category)
    user_diego = User.create!(name: 'Diego', social_name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit sale_post_path(post.id)
    click_on 'Comprar'
    post.reload

    expect(page).to have_content('Solicitação de compra enviada. Aguarde aprovação do vendedor')
    expect(post).to be_disabled
    expect(post.orders.first).to be_in_progress
    expect(page).to have_content('Em andamento')
    expect(current_path).to eq('/orders/1')
  end

  scenario 'and seller gets a notification' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_bruno = User.create!(name: 'Bruno', social_name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                            description: 'Fogão ideal pra todos', category: eletro_category)
    user_diego = User.create!(name: 'Diego', social_name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit sale_post_path(post.id)
    click_on 'Comprar'
    click_on 'Sair'
    login_as user_bruno, scope: :user
    visit root_path

    expect(user_bruno.reload.notifications.size).to eq(1)
    expect(page).to have_css('.notifications')
    within '.notifications' do
      expect(page).to have_content('1')
    end
  end
end
