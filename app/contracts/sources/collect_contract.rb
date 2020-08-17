module Sources
  class CollectContract < Dry::Rails::Features::ApplicationContract
    params do
      required(:storage_names).array(:string)
      required(:source_names).array(:string)
    end
  end
end

