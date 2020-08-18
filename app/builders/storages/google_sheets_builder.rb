module Storages
  class GoogleSheetsBuilder
    extend Dry::Initializer

    SPREADSHEET_KEY = '12hEZvlN8yPyILrvLT80J_6-NDLfkmz2iJ4IX0SLeEcU'.freeze
    WORKSHEET_TITLES = {
      stocks: 'Fundamentos',
      earnings: 'Dividendos'
    }.freeze

    option :google_session, default: -> { GoogleDrive::Session.from_service_account_key(StringIO.new(ENV['GOOGLE_APPLICATION_CREDENTIALS'])) }
    option :attributes, default: -> { {} }

    def with_source_name(source_name)
      attributes[:source_name] = source_name
      self
    end

    def with_type(type)
      attributes[:type] = type
      self
    end

    def build
      worksheets = {}

      title = "#{attributes[:source_name].humanize} - #{WORKSHEET_TITLES[attributes[:type]]}"

      worksheets[attributes[:type]] = Storages::GoogleSheets::Worksheet.new(
        worksheet: find_or_create_worksheet(title)
      )

      Storages::GoogleSheets::Spreadsheet.new(worksheets: worksheets)
    end

    private

    def find_or_create_worksheet(title)
      spreadsheet.worksheet_by_title(title) || spreadsheet.add_worksheet(title)
    end

    def spreadsheet
      @spreadsheet ||= google_session.spreadsheet_by_key(SPREADSHEET_KEY)
    end
  end
end
