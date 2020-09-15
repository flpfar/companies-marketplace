require 'rails_helper'

feature 'User ask question on sale post' do
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

    expect(page).to have_content('Pergunta enviada com sucesso')
    within '.questions-container' do
      expect(page).to have_content('Diego')
      expect(page).to have_content('Faz por 250?')
    end
  end
end
