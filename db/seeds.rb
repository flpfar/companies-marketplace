# Creates a company named Coshop with domain 'coshop.com' and 9 categories
# Coshop has 6 random users, and one user 'master@coshop.com'. All of them have the password '123123'
require 'faker'

Faker::Config.locale = :'pt-BR'
I18n.reload!

coshop = Company.create!(name: 'Coshop', domain: 'coshop.com')

categories_array = ['Automotivo', 'Alimentos e Bebidas', 'Eletrodomésticos', 'Games e Consoles',
                    'Celulares', 'Informática', 'Eletrônicos', 'Livros', 'Móveis'].sort

categories_array.each do |category|
  Category.create!(name: category, company: coshop)
end

master = User.create!(
  name: 'Master Ipsum',
  role: 'Developer',
  department: 'Tecnologia',
  birth_date: '06/02/1990',
  email: 'master@coshop.com',
  password: '123123'
)

6.times do
  name = Faker::Name.unique.name
  User.create!(
    name: name,
    role: Faker::Job.title,
    department: Faker::Job.field,
    birth_date: '16/10/1988',
    email: "#{name.parameterize}@coshop.com",
    password: '123123'
  )
end

eletro_category = Category.find_by(name: 'Eletrodomésticos')

SalePost.create!(
  title: 'Geladeira Brastemp',
  price: '800',
  description: Faker::Company.catch_phrase,
  user_id: master.id,
  category_id: eletro_category.id
).cover.attach(io: File.open(Rails.root.join('spec/support/geladeira.jpg')), filename: 'geladeira.jpg')

SalePost.create!(
  title: 'Fogão Dako',
  price: '300',
  description: Faker::Lorem.paragraph,
  user_id: master.id,
  category_id: eletro_category.id
).cover.attach(io: File.open(Rails.root.join('spec/support/fogao.jpg')), filename: 'fogao.jpg')

14.times do
  SalePost.create!(
    title: Faker::Commerce.product_name,
    price: rand(500..1500),
    description: Faker::Lorem.paragraph,
    user_id: rand(1..7),
    category_id: rand(1..9)
  )
end
