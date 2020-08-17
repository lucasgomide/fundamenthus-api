module Sources
  class CollectBuilder
    include Dry::Monads[:result]
    extend Dry::Initializer
    include Fundamenthus::Deps[
      storage_factory: 'storages.builder_factory'
    ]

    option :attributes, default: -> { {} }

    def from_contract(contract)
      attributes[:source_name] = contract[:source_name]
      attributes[:storage_names] = contract[:storage_names]

      self
    end

    def build
      storages = attributes[:storage_names].map { |s| build_storage(s, attributes[:source_name]) }

      Success(Sources::Collect.new(
        storages: storages,
        source_name: attributes[:source_name],
      ))
    end

    private

    def build_storage(storage_name, source_name)
      builder = storage_factory.create_for(storage_name)
      builder.add_source_name(source_name)
             .build
    end
  end
end
