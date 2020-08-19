# frozen_string_literal: true

RSpec.describe Storages::MongoDb::Collection, type: :storage do
  subject(:storage) do
    described_class.new(models: models)
  end
  let(:earninng) { Earning.create_with(source: 'abc') }
  let(:models) { { stocks: earninng } }

  context '.name' do
    subject(:name) { storage.name }
    it { is_expected.to eq(:mongo_db) }
  end

  context '.create' do
    subject(:create) { storage.create(result) }
    let(:result) do
      [
        {
          company_info: { name: 'Company ABC', ticker_symbol: 'ACB123' },
          key_1: 'value 1',
          key_2: 'value 2',
        },
        {
          company_info: { name: 'Company ABC1', ticker_symbol: 'ACB12' },
          key_1: 'value 1',
          key_2: 'value 2',
        },
        {
          company_info: { name: 'Company ABC', ticker_symbol: 'ACB123' },
          key_1: 'value 1',
          key_2: 'value 2',
        },
      ]
    end

    it { is_expected.to eq(stocks: Success(:created)) }

    it do
      expect { create }.to change { Earning.count }.from(0).to(3)
    end

    it do
      expect { create }.to change { Company.count }.from(0).to(2)
    end

    it do
      create
      expect(Earning.pluck(:data)).to match_array([{ key_1: 'value 1', key_2: 'value 2' }] * 3)
    end
  end
end

