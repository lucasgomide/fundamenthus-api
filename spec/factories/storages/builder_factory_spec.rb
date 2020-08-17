# frozen_string_literal: true

RSpec.describe Storages::BuilderFactory, type: :factory do
  subject(:factory) { described_class.new }

  describe '.create_for' do
    subject(:create_for) { factory.create_for(storage_name) }

    context 'when storage builder does exists' do
      let(:storage_name) { 'google_sheets' }
      it { is_expected.to be_instance_of(Storages::GoogleSheetsBuilder) }
    end
  end
end
