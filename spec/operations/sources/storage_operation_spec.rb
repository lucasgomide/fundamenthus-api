# frozen_string_literal: true

RSpec.describe StorageOperation, type: :operation do
  subject(:storage_operation) { described_class.new }

  context '.call' do
    subject(:call) { storage_operation.call(result, storages) }
    let(:result) { [] }

    context 'when storages is empty' do
      let(:storages) { [] }
      it { is_expected.to be_success.with({}) }
    end

    context 'when storages is empty' do
      let(:dummy_storage) do
        Class.new do
          def name
            :storage_name
          end

          def create(_);end
        end.new
      end

      let(:result) { success(:done) }

      before do
        allow(dummy_storage).to receive(:create).and_return(result)
      end

      let(:storages) { [dummy_storage] }
      it { is_expected.to be_success.with(storage_name: result) }

      context 'when store creation has failed' do
        let(:result) { failure(:failed) }
        it { is_expected.to be_success.with(storage_name: result) }
      end
    end
  end
end
