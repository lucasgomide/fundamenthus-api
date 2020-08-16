# frozen_string_literal: true

RSpec.describe Storages::GoogleSheets::Spreadsheet, type: :storage do
  subject(:storage) do
    described_class.new(worksheets: worksheets)
  end
  let(:worksheet) { instance_spy(Storages::GoogleSheets::Worksheet) }
  let(:worksheets) { { stocks: worksheet } }

  context '.name' do
    subject(:name) { storage.name }
    it { is_expected.to eq(:google_sheets) }
  end

  context '.create' do
    subject(:create) { storage.create(result) }
    let(:result) { [] }
    let(:creation_result) { { stocks: Success(:ok)} }
    before do
      allow(worksheet).to receive(:save).and_return(Success(:ok))
    end

    it do
      create
      expect(worksheet).to have_received(:save).with(result)
    end

    it { is_expected.to eq(creation_result) }
  end
end
