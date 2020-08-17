module Storages
  class BuilderFactory
    def create_for(storage_type)
      Fundamenthus::Container.resolve("storages.#{storage_type}_builder")
    end
  end
end
