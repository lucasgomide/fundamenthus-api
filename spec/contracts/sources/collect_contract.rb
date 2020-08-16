# frozen_string_literal: true

RSpec.describe Sources::CollectContract, type: :operation do
  subject(:contract) { described_class.new }

  describe '.call' do
    subject(:call) { contract.call(input).to_monad }

    context 'when valid input' do
      let(:input) do
        {
          storage_names: ['abc'],
          source_name: 'b3',
        }
      end

      it { is_expected.to be_success }
    end

    context 'when invalid input' do
      subject(:errors) { call.failure.errors.to_h }
      let(:input) do
        {
          storage_names: 123,
          source_name: nil,
        }
      end

      its([:source_name]) { is_expected.to match_array('must be filled') }
      its([:storage_names]) { is_expected.to match_array('must be an array') }
    end
  end
end
