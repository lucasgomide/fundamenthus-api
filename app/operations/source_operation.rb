class SourceOperation
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  include Fundamenthus::Deps[
    collect_contract: 'sources.collect_contract',
    collect_builder: 'sources.collect_builder',
    storage_operation: 'storage_operation'
  ]

  def call(input)
    contract = yield collect_contract.call(input)
    contract[:source_names].collect do |source_name|
      [:stocks, :earnings].map do |type|
        source_collect = yield collect_builder.with_source_name(source_name)
                                              .with_storages_names(contract[:storage_names])
                                              .with_type(type)
                                              .build

        result = yield source_collect.source.call(type)

        storage_operation.call(result, source_collect.storages)
      end
    end.flatten
  end
end
