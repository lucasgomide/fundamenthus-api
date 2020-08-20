module Storages
  module GoogleSheets
    class Worksheet
      include Dry::Monads[:result]
      extend Dry::Initializer

      option :worksheet

      def save(result)
        return Success(:no_result) if result.blank?

        data = rebuid_result(result)

        data.first.keys.each_with_index do |key, index|
          worksheet[1, index + 1] = key
        end

        data.each_with_index do |item, head|
          item.values.each_with_index do |key, index|
            worksheet[head + 2, index + 1] = key
          end
        end

        worksheet.save

        Success(:saved)
      end

      def rebuid_result(result)
        [].tap do |data|
          result.each_with_index do |r, i|
            data[i] = {}
            r.keys.each do |key|
              if r[key].is_a?(Hash)
                r[key].keys.each(& -> k { data[i]["#{key}.#{k}"] = r[key][k] })
              else
                data[i][key] = r[key]
              end
            end
          end
        end
      end
    end
  end
end
