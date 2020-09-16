require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'validation' do
    it 'body cant be blank' do
      company = Company.create!(name: 'Coshop', domain: 'coshop.com')
      category = company.categories.create!(name: 'Games')
      seller = User.create!(name: 'Seller', email: 'seller@coshop.com', password: '123123')
      buyer = User.create!(name: 'Buyer', email: 'buyer@coshop.com', password: '123123')
      post = seller.sale_posts.create!(title: 'Sale Post', description: 'my sale post', price: 123, category: category)
      question = post.questions.create!(body: 'Is it new?', user: buyer)
      answer = Answer.new(question: question)

      answer.valid?

      expect(answer.errors[:body]).to include('não pode ficar em branco')
    end

    it 'must be unique for a question' do
      company = Company.create!(name: 'Coshop', domain: 'coshop.com')
      category = company.categories.create!(name: 'Games')
      seller = User.create!(name: 'Seller', email: 'seller@coshop.com', password: '123123')
      buyer = User.create!(name: 'Buyer', email: 'buyer@coshop.com', password: '123123')
      post = seller.sale_posts.create!(title: 'Sale Post', description: 'my sale post', price: 123, category: category)
      question = post.questions.create!(body: 'Is it new?', user: buyer)
      Answer.create!(body: 'Yes!', question: question)
      answer = Answer.new(body: 'It depends.', question: question)

      answer.valid?

      expect(answer.errors[:question]).to include('já está em uso')
    end
  end
end
