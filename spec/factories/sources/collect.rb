FactoryBot.define do
  factory :source_collect, class: Sources::Collect do
    source_name { 'source-default' }
    storages { ['first-storage'] }

    initialize_with  { new(attributes) }
  end
end
