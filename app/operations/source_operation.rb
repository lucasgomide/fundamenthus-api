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
    source_collect = yield collect_builder.from_contract(contract).build
    result = yield source_collect.source.call

    storage_operation.call(result, source_collect.storages)
  end
end
