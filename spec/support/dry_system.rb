# frozen_string_literal: true

RSpec.shared_context 'with controller_container_stubs', shared_context: :metadata do
  let(:app_container_stubs) {}

  before do
    app_container_stubs

    controller.class == described_class &&
      self.controller = described_class.new
  end

  after do
    AffiliateApi::Container.unstub
  end
end

RSpec.shared_context 'with container_stubs', shared_context: :metadata do
  let(:app_container_stubs) {}

  before do
    app_container_stubs
  end

  after do
    AffiliateApi::Container.unstub
  end
end
