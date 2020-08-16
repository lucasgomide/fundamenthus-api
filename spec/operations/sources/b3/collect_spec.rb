# frozen_string_literal: true

RSpec.describe Sources::B3::Collect, type: :operation do
  subject(:collect) { described_class.new }
  subject(:b3_client) { class_spy(Fundamenthus::Source::B3) }

  let(:app_container_stubs) do
    Fundamenthus::Container.stub('fundamenthus.b3', b3_client)
  end

  describe '.call' do
    subject(:collect_call) { collect.call }
    let(:result) { ['any-result'] }
    before do
      allow(b3_client).to receive(:stocks).and_return(result)
    end

    it { is_expected.to be_success.with(result) }
    it do
      collect_call
      expect(b3_client).to have_received(:stocks)
    end
  end
end
