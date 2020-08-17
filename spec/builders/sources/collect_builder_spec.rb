# frozen_string_literal: true

RSpec.describe Sources::CollectBuilder, type: :builder do
  subject(:builder) { described_class.new }
  let(:storage_factory) { instance_spy(Storages::BuilderFactory) }

  let(:app_container_stubs) do
    Fundamenthus::Container.stub('storages.builder_factory', storage_factory)
  end
  let(:type) { 'some-type' }
  let(:source_name) { 'abc' }
  let(:storage_names) { ['first-storage', 'second-storage'] }
  let(:hash_contract) do
    {
      source_name: source_name,
      storage_names: storage_names,
      type: type
    }
  end

  context '.with_source_name' do
    subject(:with_source_name) { builder.with_source_name(source_name) }

    it { is_expected.to be_an_instance_of(Sources::CollectBuilder) }
    its(:attributes) { is_expected.to eql(source_name: source_name) }
  end

  context '.with_storages_names' do
    subject(:with_storages_names) { builder.with_storages_names(storage_names) }

    it { is_expected.to be_an_instance_of(Sources::CollectBuilder) }
    its(:attributes) { is_expected.to eql(storage_names: storage_names) }
  end

  context '.with_type' do
    subject(:with_type) { builder.with_type(type) }

    it { is_expected.to be_an_instance_of(Sources::CollectBuilder) }
    its(:attributes) { is_expected.to eql(type: type) }
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
      aggregate_failures do
        expect(storage_builder).to have_received(:with_source_name).with(source_name).twice
        expect(storage_builder).to have_received(:with_type).with(type).twice
        expect(storage_builder).to have_received(:build).twice
      end
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
