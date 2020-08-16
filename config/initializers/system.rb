Dry::Rails.container do
  config.features = %i[
    application_contract
    safe_params
  ]

  config.root = (Pathname.pwd + 'app')

  custom_paths = [
    'operations',
    'contracts',
  ]

  namespace(:fundamenthus) do
    register(:b3) { Fundamenthus::Source::B3 }
    register(:status_invest) { Fundamenthus::Source::StatusInvest }
  end

  auto_register!(*custom_paths)
end
