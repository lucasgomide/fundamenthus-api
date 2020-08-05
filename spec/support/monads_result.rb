# frozen_string_literal: true

require 'dry/monads/result'
require 'dry/monads/list'
require 'dry/transaction/result_matcher'
require 'dry/matcher/result_matcher'

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

  def result_matcher(value, &block)
    Dry::Matcher::ResultMatcher.call(value, &block)
  end

  def result_matcher_with_step(value, step_name, &block)
    return result_matcher(value, &block) if value.success?

    step = OpenStruct.new(name: step_name.to_sym)

    result = Dry::Transaction::StepFailure.new(step, value.failure)
    Dry::Transaction::ResultMatcher.call(failure(result), &block)
  end

  def result_matcher_without_case(value, &block)
    Dry::Matcher.new.call(value, &block)
  end

  def matcher_evaluator(result)
    cases = Dry::Matcher::ResultMatcher.cases
    Dry::Matcher::Evaluator.new(result, cases)
  end
end

RSpec.configure do |config|
  config.include MonadsResult
end
