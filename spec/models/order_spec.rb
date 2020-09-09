require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'buyer must have unique order in progress on sale post' do
    company = Company.create!(name: 'Coke', domain: 'coke.com')
    category = company.categories.create!(name: 'Games')
    seller = User.create!(name: 'Seller', email: 'seller@coke.com', password: '123123')
    buyer = User.create!(name: 'Buyer', email: 'buyer@coke.com', password: '123123')
    post1 = seller.sale_posts.create!(title: 'Xbox One', price: 1000, description: 'Xbox one com 2 controles',
                                      category: category)
    Order.create!(item_name: post1.title, item_description: post1.description, sale_post: post1,
                  posted_price: post1.price, status: :in_progress, buyer: buyer, seller: seller)
    duplicated_order = Order.new(item_name: post1.title, item_description: post1.description, sale_post: post1,
                                 posted_price: post1.price, status: :in_progress, buyer: buyer, seller: seller)

    duplicated_order.valid?

    expect(duplicated_order.errors[:sale_post]).to include('já está em uso')
  end
end
