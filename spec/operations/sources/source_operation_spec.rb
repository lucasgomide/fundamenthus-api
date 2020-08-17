# frozen_string_literal: true

RSpec.describe SourceOperation, type: :operation do
  subject(:source_operation) { described_class.new }
  # let(:collect_contract) { instance_spy(Sources::CollectContract) }
  let(:collect_builder) { instance_spy(Sources::CollectBuilder) }
  let(:storage_operation) { instance_spy(StorageOperation) }

  let(:app_container_stubs) do
    # Fundamenthus::Container.stub('sources.collect_contract', collect_contract)
    Fundamenthus::Container.stub('sources.collect_builder', collect_builder)
    Fundamenthus::Container.stub('storage_operation', storage_operation)
  end

  context '.call' do
    subject(:call) { source_operation.call(input) }
    let(:source_names) { ['b3'] }
    let(:storage_names) { ['google_sheets'] }
    let(:input) { { source_names: source_names, storage_names: storage_names } }

    let(:builder_result) { success(source_collect) }
    let(:source_collect) { build(:source_collect) }
    let(:storage_result) { success({ storage: :ok }) }
    let(:source) { spy(OpenStruct) }
    let(:source_result) { success([]) }

    before do
      allow(collect_builder).to receive(:build).and_return(builder_result)
      allow(storage_operation).to receive(:call).and_return(storage_result)

      allow(source_collect).to receive(:source).and_return(source)
      allow(source).to receive(:call).and_return(source_result)
    end

    it { is_expected.to match_array([Success({ storage: :ok }), Success({ storage: :ok })]) }

    it do
      call
      aggregate_failures do
        expect(collect_builder).to have_received(:with_source_name).with(source_names.first).twice
        expect(collect_builder).to have_received(:with_storages_names).with(storage_names).twice
        expect(collect_builder).to have_received(:with_type).with(:stocks)
        expect(collect_builder).to have_received(:with_type).with(:earnings)
        expect(collect_builder).to have_received(:build).twice
      end
    end

    it do
      call
      aggregate_failures do
        expect(source_collect).to have_received(:source).twice
        expect(source).to have_received(:call).twice
      end
    end

    it do
      call
      expect(storage_operation).to have_received(:call).with([], source_collect.storages).twice
    end

    context 'when contract validatio has failed' do
      let(:input) { { invalid_contract: 'invalid' } }
      it { is_expected.to be_failed.with_instance_of(Dry::Validation::Result) }
    end

    context 'when source collect build has failed' do
      let(:builder_result) { failure(:any_error) }
      it { is_expected.to be_failed.with(:any_error) }
    end

    context 'when data collection from source has failed' do
      let(:source_result) { failure(:source_call_failed) }
      it { is_expected.to be_failed.with(:source_call_failed) }
    end

    context 'when the store data has failed' do
      let(:storage_result) { failure(:store_result_failed) }
      it { is_expected.to match_array([failure(:store_result_failed), failure(:store_result_failed)]) }
    end
  end
end
