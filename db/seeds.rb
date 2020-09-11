# Creates a company named Coshop with domain 'coshop.com' and 8 categories
# Coshop has one user 'master@coshop.com' with password '123123'
# Master has 4 posts in random days

# COMPANY
coshop = Company.create!(name: 'Coshop', domain: 'coshop.com')

# CATEGORIES
categories_array = ['Automotivo', 'Games e Consoles', 'Celulares',
                    'Eletrônicos', 'Livros', 'Alimentos e Bebidas']
categories_array.each do |category|
  Category.create!(name: category, company: coshop)
end
eletro_category = coshop.categories.create!(name: 'Eletrodomésticos')
info_category = coshop.categories.create!(name: 'Informática')

# USER
master = User.create!(
  name: 'Master Ipsum',
  role: 'Developer',
  department: 'Tecnologia',
  birth_date: '06/02/1990',
  email: 'master@coshop.com',
  password: '123123'
)

# POSTS
geladeira_description = "Geladeira Electrolux 251 litros\nModelo Electrolux DC33, Super Freezer\n"\
                        'Ótimo estado, tudo funcionando, com todas as prateleiras, sem nenhum ferrugem.'
geladeira = SalePost.create!(
  title: 'Geladeira Electrolux',
  price: '800',
  description: geladeira_description,
  user_id: master.id,
  category_id: eletro_category.id
)
geladeira.cover.attach(io: File.open(Rails.root.join('spec/support/geladeira.jpg')), filename: 'geladeira.jpg')
geladeira.update(created_at: (rand * 10).days.ago)

fogao_description = "Fogão 4 bocas usado.\n4 chamas e o forno perfeitos"
fogao = SalePost.create!(
  title: 'Fogão',
  price: '100',
  description: fogao_description,
  user_id: master.id,
  category_id: eletro_category.id
)
fogao.cover.attach(io: File.open(Rails.root.join('spec/support/fogao.jpg')), filename: 'fogao.jpg')
fogao.update(created_at: (rand * 10).days.ago)

note_description = "Intel core i5\nHD 500gb ou SSD 120gb (+R$250,00)\n4 GB de RAM\nTela 14 pol\nBateria boa\n"\
                   "Bluetooth\n\nNotebook bem conservado\n90 dias de garantia"
note = SalePost.create!(
  title: 'Notebook Dell i5',
  price: '1500',
  description: note_description,
  user_id: master.id,
  category_id: info_category.id
)
note.cover.attach(io: File.open(Rails.root.join('spec/support/notebook.jpg')), filename: 'notebook.jpg')
note.update(created_at: (rand * 10).days.ago)

pc_description = "Intel Celeron E3300 2.50GHz\nPlaca Mãe Asus P5LD2-X/1333 Soquete LGA775\n4GB Ram DDR2\n"\
  "HD320 GB.\nWindows 10 Pró 64 Bits.\nPlaca de Vídeo Asus EN210 Silent 1GB DDR3 64 Bits. HDMI.\n"\
  "Fonte PC Top 500 Watts.\n\n*Somente o Computador, não acompanha teclado, mouse e monitor!*Apesar de ser"\
  'uma máquina antiga, funciona perfeitamente, é bem rápido, excelente para navegação na internet, assistir'\
  "aulas online, vídeos e etc.\nPacote office 2016 instalado."
pc = SalePost.create!(
  title: 'Computador',
  price: '250',
  description: pc_description,
  user_id: master.id,
  category_id: info_category.id
)
pc.cover.attach(io: File.open(Rails.root.join('spec/support/test-image.jpg')), filename: 'test-image.jpg')
pc.update(created_at: (rand * 10).days.ago)
