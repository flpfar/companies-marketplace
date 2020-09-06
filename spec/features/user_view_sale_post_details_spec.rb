require 'rails_helper'

feature 'User views sale post details' do
  scenario 'must be logged in' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                            description: 'Fogão ideal pra todos', category: eletro_category)

    visit sale_post_path(post.id)

    expect(current_path).not_to eq(sale_post_path(post.id))
    expect(page).not_to have_content(post.title)
    expect(page).to have_content('Para continuar, faça login ou registre-se')
  end

  scenario 'successfully' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    disabled_user = User.create!(email: 'maria@coke.com.br', password: '123123')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                     description: 'Fogão ideal pra todos', category: eletro_category)
    sale_post_refrigerator = SalePost.create!(title: 'Geladeira Brastemp', price: '800', user: user_bruno,
                                              description: 'Geladeira semi nova, em ótimo estado',
                                              category: eletro_category)

    login_as disabled_user, scope: :user
    visit root_path
    find(".post-item[data-item='#{sale_post_refrigerator.id}']").click

    within '.post-container' do
      expect(page).to have_content(sale_post_refrigerator.title)
      expect(page).to have_content(sale_post_refrigerator.description)
      expect(page).to have_content(sale_post_refrigerator.category.name)
      expect(page).to have_content("R$ #{sale_post_refrigerator.price},00")
    end
  end

  context 'and buy button' do
    scenario 'is available if user enabled and is not the owner' do
      coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
      eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
      user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                                department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
      user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                                role: 'Auxiliar', department: 'Comercial',
                                email: 'diego@coke.com.br', password: '123123')
      post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                              description: 'Fogão ideal pra todos', category: eletro_category)

      login_as user_diego, scope: :user
      visit sale_post_path(post.id)

      expect(page).to have_link('Comprar')
    end

    scenario 'is not available if user not enabled' do
      coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
      disabled_user = User.create!(email: 'maria@coke.com.br', password: '123123')
      eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
      user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                                department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
      post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                              description: 'Fogão ideal pra todos', category: eletro_category)

      login_as disabled_user, scope: :user
      visit sale_post_path(post.id)

      expect(page).not_to have_link('Comprar')
    end

    scenario 'is not available if current_user is the owner' do
      coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
      eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
      user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                                department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
      post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                              description: 'Fogão ideal pra todos', category: eletro_category)

      login_as user_bruno, scope: :user
      visit sale_post_path(post.id)

      expect(page).not_to have_link('Comprar')
    end
  end
end
