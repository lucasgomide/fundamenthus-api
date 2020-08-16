module Storages
  module GoogleSheets
    class Worksheet
      include Dry::Monads[:result]
      extend Dry::Initializer

      option :worksheet

      def save(result)
        return Success(:no_result) if result.blank?

        result.first.keys.each_with_index do |key, index|
          worksheet[1, index + 1] = key
        end

        result.each_with_index do |item, head|
          item.values.each_with_index do |key, index|
            worksheet[head + 2, index + 1] = key
          end
        end

        worksheet.save

        Success(:saved)
      end
    end
  end
end
