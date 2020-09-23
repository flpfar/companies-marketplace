FactoryBot.define do
  factory :user do
    name { 'Coshop' }
    email { 'coshop@coshop.com' }
    password { '123123' }
    birth_date { '18/10/90' }
    role { 'Manager' }
    department { 'Sales' }
  end
end
