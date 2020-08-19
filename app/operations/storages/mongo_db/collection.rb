module Storages
  module MongoDb
    class Collection
      include Dry::Monads[:result]
      extend Dry::Initializer

      option :models, default: -> { {} }

      def create(result)
        {}.tap do |obj|
          models.keys.each do |k|
            result.map(&method(:build_data))
                  .map(&models[k].method(:create!))
            obj[k] = Success(:created)
          end
        end
      end

      def name
        :mongo_db
      end

      private

      def build_data(result)
        {
          company: Company.find_or_create_by(result[:company_info]),
          data: result.except(:company_info)
        }
      end
    end
  end
end
