module Storages
  class MongoDbBuilder
    extend Dry::Initializer

    MODELS_MAPPING = {
      stocks: 'Fundamental',
      earnings: 'Earning'
    }
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
      models = {
        attributes[:type] => MODELS_MAPPING[attributes[:type]].constantize.create_with(
          source: attributes[:source_name]
        )
      }

      Storages::MongoDb::Collection.new(models: models)
    end
  end
end
