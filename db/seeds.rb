# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

company = Company.create(name: 'Company', domain: 'company.com')

categories_array = ['Automotivo', 'Alimentos e Bebidas', 'Beleza', 'Games e Consoles',
                    'Celulares', 'Informática', 'Eletrônicos', 'Livros', 'Móveis'].sort

categories_array.each do |category|
  # Category.create(name: category, )
end

user = User.create!(name: 'User', social_name: 'User',
                    role: 'Dev', department: 'T.I', birth_date: '18/10/90',
                    email: 'user@company.com', password: '123123')

