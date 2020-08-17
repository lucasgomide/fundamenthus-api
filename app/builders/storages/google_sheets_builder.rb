module Storages
  class GoogleSheetsBuilder
    extend Dry::Initializer

    SPREADSHEET_KEY = '12hEZvlN8yPyILrvLT80J_6-NDLfkmz2iJ4IX0SLeEcU'.freeze
    WORKSHEET_TITLES = {
      stocks: 'Fundamentos'
    }.freeze

    option :google_session, default: -> { GoogleDrive::Session.from_config('config/gcp_config.json') }
    option :attributes, default: -> { {} }

    def add_source_name(source_name)
      attributes[:source_name] = source_name
      self
    end

    def build
      worksheets = {}
      [:stocks].each do |type|
        title = "#{attributes[:source_name].humanize} - #{WORKSHEET_TITLES[type]}"

        worksheets[type] = Storages::GoogleSheets::Worksheet.new(
          worksheet: find_or_create_worksheet(title)
        )
      end

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
