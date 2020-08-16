module Storages
  module GoogleSheets
    require 'google_drive'

    class Spreadsheet
      include Dry::Monads[:result]
      extend Dry::Initializer

      option :worksheets, default: -> { {} }

      def create(result)
        {}.tap do |data|
          worksheets.keys.each do |k|
            data[k] = worksheets[k].save(result)
          end
        end
      end

      def name
        :google_sheets
      end
    end
  end
end


