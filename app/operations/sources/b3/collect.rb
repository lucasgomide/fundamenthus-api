module Sources
  module B3
    class Collect
      include ::Sources::Base
      include Fundamenthus::Deps[
        client: 'fundamenthus.b3'
      ]
    end
  end
end
