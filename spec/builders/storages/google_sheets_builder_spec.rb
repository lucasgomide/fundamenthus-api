# frozen_string_literal: true

RSpec.describe Storages::GoogleSheetsBuilder, type: :builder do
  let(:google_session) { instance_spy(GoogleDrive::Session) }
  subject(:builder) do
    described_class.new(google_session: google_session)
  end

  it { expect(described_class::SPREADSHEET_KEY).to eql('12hEZvlN8yPyILrvLT80J_6-NDLfkmz2iJ4IX0SLeEcU') }

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
    let(:builder) do
      described_class.new(google_session: google_session, attributes: { type: type, source_name: 'the_source_name' })
    end
    let(:type) { :stocks }

    subject(:builder_build) { builder.build }

    let(:spreadsheet) { instance_spy(GoogleDrive::Spreadsheet) }
    let(:worksheet) { instance_spy(GoogleDrive::Worksheet) }

    before do
      allow(google_session).to receive(:spreadsheet_by_key).and_return(spreadsheet)
      allow(spreadsheet).to receive(:worksheet_by_title).and_return(worksheet)
    end

    it { is_expected.to be_instance_of(Storages::GoogleSheets::Spreadsheet) }

    it do
      builder_build
      expect(google_session).to have_received(:spreadsheet_by_key).with(described_class::SPREADSHEET_KEY)
    end

    context 'when type is earnings' do
      let(:type) { :earnings }

      it do
        builder_build
        expect(spreadsheet).to have_received(:worksheet_by_title).with('The source name - Dividendos')
      end
    end

    it do
      builder_build
      expect(spreadsheet).to have_received(:worksheet_by_title).with('The source name - Fundamentos')
    end

    it do
      builder_build
      expect(spreadsheet).not_to have_received(:add_worksheet).with('The source name - Fundamentos')
    end

    context 'when the worksheet does not exists' do
      let(:worksheet) { nil }

      it do
        builder_build
        expect(spreadsheet).to have_received(:add_worksheet).with('The source name - Fundamentos')
      end
    end

    context 'checking worksheets' do
      it do
        expect(builder_build.worksheets[:stocks]).to be_an_instance_of(Storages::GoogleSheets::Worksheet)
      end
      it do
        expect(builder_build.worksheets[:stocks].worksheet).to eql(worksheet)
      end
    end
  end

  context 'by checking google_session' do
    subject(:builder) { described_class.new }

    its(:google_session) { is_expected.to be_an_instance_of(GoogleDrive::Session) }
  end
end
