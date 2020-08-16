module Storages
  class GoogleSheetsBuilder
    extend Dry::Initializer

    SPREADSHEET_KEY = '12hEZvlN8yPyILrvLT80J_6-NDLfkmz2iJ4IX0SLeEcU'.freeze

    option :google_session, default: -> { GoogleDrive::Session.from_config('config/gcp_config.json') }
    option :attributes, default: -> { {} }

    def build
      spreadsheet = google_session.spreadsheet_by_key(SPREADSHEET_KEY)

      worksheets = {}
      [:stocks].each do |type|
        worksheets[type] = Storages::GoogleSheets::Worksheet.new(
          worksheet: spreadsheet.worksheet_by_title(type)
        )
      end

      Storages::GoogleSheets::Spreadsheet.new(worksheets: worksheets)
    end
  end
end
