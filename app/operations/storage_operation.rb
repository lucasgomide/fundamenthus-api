class StorageOperation
  include Dry::Monads[:result]

  def call(result, storages)
    Success({}.tap do |data|
      storages.each(& -> storage {
        data[storage.name] = storage.create(result)
      })
    end)
  end
end
