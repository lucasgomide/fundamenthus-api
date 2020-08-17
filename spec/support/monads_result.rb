# frozen_string_literal: true

require 'dry/monads/result'
require 'dry/monads/list'

module MonadsResult
  include Dry::Monads::Result::Mixin
  include Dry::Monads::List::Mixin

  def success(value)
    Dry::Monads.Success(value)
  end

  def failure(value)
    Dry::Monads.Failure(value)
  end

  def list(*value)
    Dry::Monads::List[*value]
  end

  def validation_contract_result(success: true)
    schema = Class.new(Dry::Validation::Contract) do
      schema do
        required(:success)
      end
      rule(:success) do
        key.failure('failure') unless success
      end
    end.new
    schema.(success: success).to_monad
  end
end

RSpec.configure do |config|
  config.include MonadsResult
end
