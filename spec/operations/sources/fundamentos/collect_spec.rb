# frozen_string_literal: true

RSpec.describe Sources::Fundamentos::Collect, type: :operation do
  subject(:collect) { described_class.new }
  let(:fundamentos_client) { class_spy(Fundamenthus::Source::Fundamentos) }

  let(:app_container_stubs) do
    Fundamenthus::Container.stub('fundamenthus.fundamentos', fundamentos_client)
  end

  describe '.call' do
    subject(:collect_call) { collect.call(collect_type) }
    let(:result) { ['any-result'] }
    let(:collect_type) { 'stocks' }

    before do
      allow(fundamentos_client).to receive(:stocks).and_return(result)
    end

    it { is_expected.to be_success.with(result) }
    it do
      collect_call
      expect(fundamentos_client).to have_received(:stocks)
    end
  end
end
