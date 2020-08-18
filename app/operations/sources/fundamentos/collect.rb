module Sources
  module Fundamentos
    class Collect
      include ::Sources::Base
      include Fundamenthus::Deps[
        client: 'fundamenthus.fundamentos'
      ]
    end
  end
end
