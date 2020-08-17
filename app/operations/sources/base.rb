require 'active_support/concern'
module Sources
  module Base
    extend ActiveSupport::Concern

    included do
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def call(collect_type)
        Success(client.send(collect_type))
      end
    end
  end
end
