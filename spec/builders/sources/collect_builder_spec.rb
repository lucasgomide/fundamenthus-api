# frozen_string_literal: true

RSpec.describe Sources::CollectBuilder, type: :builder do
  subject(:builder) { described_class.new }
  let(:storage_factory) { instance_spy(Storages::BuilderFactory) }

  let(:app_container_stubs) do
    Fundamenthus::Container.stub('storages.builder_factory', storage_factory)
  end
  let(:source_name) { 'abc' }
  let(:storage_names) { ['first-storage', 'second-storage'] }
  let(:hash_contract) do
    {
      source_name: source_name,
      storage_names: storage_names
    }
  end

  context '.from_contract' do
    subject(:from_contract) { builder.from_contract(hash_contract) }
    it { is_expected.to be_an_instance_of(Sources::CollectBuilder) }
    its(:attributes) { is_expected.to eql(hash_contract) }
  end

  context '.build' do
    let(:builder) { described_class.new(attributes: hash_contract) }
    let(:storage_builder) { instance_spy(Storages::GoogleSheetsBuilder) }
    let(:storage) { instance_spy(OpenStruct) }
    subject(:collect_build) { builder.build }

    before do
      allow(storage_factory).to receive(:create_for).and_return(storage_builder)
      allow(storage_builder).to receive(:build).and_return(storage)
    end

    it do
      collect_build
      aggregate_failures do
        expect(storage_factory).to have_received(:create_for).with(storage_names.first)
        expect(storage_factory).to have_received(:create_for).with(storage_names.second)
      end
    end

    it do
      collect_build
      expect(storage_builder).to have_received(:build).twice
    end

    it { is_expected.to be_success.with_instance_of(Sources::Collect) }

    context 'by checking the attributes of collection' do
      subject(:attributes) { collect_build.value! }

      its(:storages) do
        is_expected.to match_array([
          be_an_instance_of(storage.class),
          be_an_instance_of(storage.class)
        ])
      end
      its(:source_name) { is_expected.to eql(source_name) }
    end
  end
end
