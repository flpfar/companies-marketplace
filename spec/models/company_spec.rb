require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'validation' do
    it 'attributes cant be blank' do
      company = Company.new

      company.valid?

      expect(company.errors[:name]).to include('não pode ficar em branco')
      expect(company.errors[:domain]).to include('não pode ficar em branco')
    end

    it 'domain is not valid if there are uppercase letters' do
      company = Company.new(name: 'Coke', domain: 'Coke.com')

      company.valid?

      expect(company.errors[:domain]).to include('não é válido')
    end

    it 'domain is not valid if it doesnt match the domain requirements' do
      company1 = Company.new(name: 'Coke', domain: 'coke.com.')
      company2 = Company.new(name: 'Aqua', domain: '.aqua.com')
      company3 = Company.new(name: 'Lime', domain: 'limecom')

      company1.valid?
      company2.valid?
      company3.valid?

      expect(company1.errors[:domain]).to include('não é válido')
      expect(company2.errors[:domain]).to include('não é válido')
      expect(company3.errors[:domain]).to include('não é válido')
    end

    it 'domain is valid' do
      company1 = Company.new(name: 'Coke', domain: 'coke.com')
      company2 = Company.new(name: 'Aqua', domain: 'aqua.com.br')
      company3 = Company.new(name: 'Lime', domain: 'lim3.com')

      company1.valid?
      company2.valid?
      company3.valid?

      expect(company1.errors[:domain]).to be_empty
      expect(company2.errors[:domain]).to be_empty
      expect(company3.errors[:domain]).to be_empty
    end

    it 'domain must be unique' do
      Company.create!(name: 'Coke', domain: 'coke.com')
      company2 = Company.new(name: 'Aqua', domain: 'coke.com')

      company2.valid?

      expect(company2.errors[:domain]).to include('já está em uso')
    end
  end
end
