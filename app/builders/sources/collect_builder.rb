module Sources
  class CollectBuilder
    include Dry::Monads[:result]
    extend Dry::Initializer
    include Fundamenthus::Deps[
      storage_factory: 'storages.builder_factory'
    ]

    option :attributes, default: -> { {} }

    def with_source_name(source_name)
      attributes[:source_name] = source_name
      self
    end

    def with_storages_names(storage_names)
      attributes[:storage_names] = storage_names
      self
    end

    def with_type(type)
      attributes[:type] = type
      self
    end

    def build
      storages = attributes[:storage_names].map(&method(:build_storage))

      Success(Sources::Collect.new(
        storages: storages,
        source_name: attributes[:source_name],
      ))
    end

    private

    def build_storage(storage_name)
      builder = storage_factory.create_for(storage_name)
      builder.with_source_name(attributes[:source_name])
             .with_type(attributes[:type])
             .build
    end
  end
end
