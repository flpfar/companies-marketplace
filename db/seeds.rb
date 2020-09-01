# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

company = Company.create!(name: 'Company', domain: 'company.com')

categories_array = ['Automotivo', 'Alimentos e Bebidas', 'Eletrodomésticos', 'Games e Consoles',
                    'Celulares', 'Informática', 'Eletrônicos', 'Livros', 'Móveis'].sort

categories_array.each do |category|
  Category.create!(name: category, company: company)
end

user = User.create!(name: 'User', social_name: 'User',
                    role: 'Dev', department: 'T.I', birth_date: '18/10/90',
                    email: 'user@company.com', password: '123123')

eletro_category = Category.find_by(name: 'Eletrodomésticos')

SalePost.create!(title: 'Geladeira Brastemp', price: '800', user: user,
                 description: 'Geladeira semi nova, em ótimo estado',
                 category: eletro_category)
SalePost.create!(title: 'Fogão Dako', price: '300', user: user,
                 description: 'Fogão ideal pra todos', category: eletro_category)
