# frozen_string_literal: true

RSpec.describe CollectWorker, type: :worker do
  subject(:worker) { described_class.new(operation: operation) }
  let(:operation) { instance_spy(SourceOperation) }

  context '.perform' do
    subject(:perform) { worker.perform }

    before do
      allow(worker).to receive(:operation).and_return(operation)
    end

    it do
      perform
      expect(operation).to have_received(:call).with(
        source_names: ['b3', 'status_invest', 'fundamentos'],
        storage_names: ['google_sheets', 'mongo_db']
      )
    end
  end
end
