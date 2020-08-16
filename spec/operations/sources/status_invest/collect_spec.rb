# frozen_string_literal: true

RSpec.describe Sources::StatusInvest::Collect, type: :operation do
  subject(:collect) { described_class.new }
  subject(:status_invest_client) { class_spy(Fundamenthus::Source::StatusInvest) }

  let(:app_container_stubs) do
    Fundamenthus::Container.stub('fundamenthus.status_invest', status_invest_client)
  end

  describe '.call' do
    subject(:collect_call) { collect.call }
    let(:result) { ['any-result'] }
    before do
      allow(status_invest_client).to receive(:stocks).and_return(result)
    end

    it { is_expected.to be_success.with(result) }
    it do
      collect_call
      expect(status_invest_client).to have_received(:stocks)
    end
  end
end
