module Sources
  module StatusInvest
    class Collect
      include ::Sources::Base
      include Fundamenthus::Deps[
        client: 'fundamenthus.status_invest'
      ]
    end
  end
end
