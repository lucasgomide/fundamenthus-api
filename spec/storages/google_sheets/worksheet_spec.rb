# frozen_string_literal: true

RSpec.describe Storages::GoogleSheets::Worksheet, type: :storage do
  subject(:storage) do
    described_class.new(worksheet: worksheet)
  end
  let(:worksheet) { instance_spy(GoogleDrive::Worksheet) }

  context '.save' do
    subject(:save) { storage.save(result) }

    context 'when the result is empty' do
      let(:result) { [] }
      it { is_expected.to be_success.with(:no_result) }
    end

    context 'when the result not empty' do
      let(:result) { [{ key: 'value' }] }

      it { is_expected.to be_success.with(:saved) }

      it do
        save
        expect(worksheet).to have_received(:save)
      end
    end
  end
end
