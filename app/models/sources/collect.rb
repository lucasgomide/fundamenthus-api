module Sources
  class Collect < Dry::Struct
    attribute :source_name,  Dry::Types['string']
    attribute :storages,  Dry::Types['array']

    def source
      Fundamenthus::Container.resolve("sources.#{source_name}.collect")
    end
  end
end
