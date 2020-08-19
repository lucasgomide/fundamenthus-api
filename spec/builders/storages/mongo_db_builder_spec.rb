# frozen_string_literal: true

RSpec.describe Storages::MongoDbBuilder, type: :builder do
  subject(:builder) { described_class.new }

  context '.with_source_name' do
    subject(:with_source_name) { builder.with_source_name(source_name) }
    let(:source_name) { 'any_source' }

    its(:attributes) { is_expected.to eql(source_name: source_name) }
  end

  context '.with_type' do
    subject(:with_type) { builder.with_type(type) }
    let(:type) { 'any_type' }

    its(:attributes) { is_expected.to eql(type: type) }
  end

  context '.build' do
    subject(:builder_build) { builder.build }
    let(:type) { :stocks }
    let(:builder) do
      described_class.new(attributes: { type: type, source_name: 'the_source_name' })
    end

    it { is_expected.to be_an_instance_of(Storages::MongoDb::Collection) }

    context 'by checking model attributes' do
      subject(:model) { builder_build.models[type] }

      context 'when type is stocks' do
        its(:klass) { is_expected.to eql(Fundamental) }
      end

      context 'when type is earnings' do
        let(:type) { :earnings }
        its(:klass) { is_expected.to eql(Earning) }
      end

      its(:create_attrs) { is_expected.to eql(source: 'the_source_name') }
    end
  end
end
