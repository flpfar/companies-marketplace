require 'rails_helper'

feature 'Seller answer question on sale post' do
  scenario 'sucessfully' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                            description: 'Fogão ideal pra todos', category: eletro_category)
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit sale_post_path(post.id)
    within '.questions-container' do
      fill_in 'question_body', with: 'Faz por 250?'
      click_on 'Enviar'
    end
    login_as user_bruno, scope: :user
    visit sale_post_path(post.id)
    within 'div[data-question="1"]' do
      fill_in 'answer_body', with: 'Infelizmente não consigo chegar nesse valor, amigo.'
      click_on 'Enviar'
    end

    expect(page).to have_content('Resposta enviada com sucesso')
    within 'div[data-question="1"]' do
      expect(page).to have_content('Bruno')
      expect(page).to have_content('Infelizmente não consigo chegar nesse valor, amigo.')
    end
  end

  scenario 'and answer is empty' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                            description: 'Fogão ideal pra todos', category: eletro_category)
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit sale_post_path(post.id)
    within '.questions-container' do
      fill_in 'question_body', with: 'Faz por 250?'
      click_on 'Enviar'
    end
    login_as user_bruno, scope: :user
    visit sale_post_path(post.id)
    within 'div[data-question="1"]' do
      click_on 'Enviar'
    end

    expect(page).to have_no_content('Resposta enviada com sucesso')
    expect(page).to have_content('Resposta deve conter texto')
    within 'div[data-question="1"]' do
      expect(page).to have_no_content('Bruno')
    end
  end

  scenario 'and cant have more than one answer to same question' do
    coke_company = Company.create!(name: 'Coke', domain: 'coke.com.br')
    eletro_category = Category.create!(name: 'Eletrodomésticos', company: coke_company)
    user_bruno = User.create!(name: 'Bruno', birth_date: '18/10/90', role: 'Gerente',
                              department: 'T.I', email: 'bruno@coke.com.br', password: '123123')
    post = SalePost.create!(title: 'Fogão Dako', price: '300', user: user_bruno,
                            description: 'Fogão ideal pra todos', category: eletro_category)
    user_diego = User.create!(name: 'Diego', birth_date: '18/10/90',
                              role: 'Auxiliar', department: 'Comercial',
                              email: 'diego@coke.com.br', password: '123123')

    login_as user_diego, scope: :user
    visit sale_post_path(post.id)
    within '.questions-container' do
      fill_in 'question_body', with: 'Faz por 250?'
      click_on 'Enviar'
    end
    login_as user_bruno, scope: :user
    visit sale_post_path(post.id)
    within 'div[data-question="1"]' do
      fill_in 'answer_body', with: 'Infelizmente não consigo chegar nesse valor, amigo.'
      click_on 'Enviar'
    end

    expect(page).to have_content('Resposta enviada com sucesso')
    within 'div[data-question="1"]' do
      expect(page).to have_no_css('form.answer-form')
    end
  end
end
