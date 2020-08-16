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
end

RSpec.configure do |config|
  config.include MonadsResult
end
