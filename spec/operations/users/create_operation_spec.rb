# frozen_string_literal: true

RSpec.describe Users::CreateOperation, type: :operation do
  subject(:operation) { described_class.new }

  describe '.call' do
    subject(:operation_call) { operation.call }

    it { is_expected.to be_success.with(:ok) }
  end
end
