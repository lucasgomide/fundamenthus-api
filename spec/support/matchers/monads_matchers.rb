# frozen_string_literal: true

RSpec::Matchers.define :be_success_with do |expected|
  match do |actual|
    actual.value_or(nil) == expected
  end
end

RSpec::Matchers.define :be_success do |_expected|
  include ObjectMatchers

  match do |actual|
    result, value = if actual.respond_to?(:some?)
                      [actual.some?, actual.value!]
                    else
                      [actual.success?, actual.value!]
                    end

    result &&
      match_object(result, value) &&
      match_array_of(result, value) &&
      match_instance_of(result, value) &&
      match_attributes(result, value)
  end

  chain :with, :object
  chain :with_array_of,    :object_array_type
  chain :with_instance_of, :object_type
  chain :with_attributes, :object_attributes
end

RSpec::Matchers.define :be_failed do |_expected|
  include ObjectMatchers

  match do |actual|
    value = actual.failure
    result = value.present? || value&.empty?

    result &&
      match_object(result, value) &&
      match_instance_of(result, value) &&
      match_attributes(result, value) &&
      match_errors(result, value)
  end

  chain :with, :object
  chain :with_array_of, :object_array_type
  chain :with_instance_of, :object_type
  chain :with_attributes, :object_attributes
  chain :with_errors_on, :error_key

  def match_errors(current_result, value)
    return current_result if error_key.blank?

    model = value.respond_to?(:model) ? value.model : value.record

    if model.errors.respond_to?(:messages)
      include(model.errors.messages).matches?(error_key)
    elsif value.errors.respond_to?(:messages)
      include(value.errors.messages).matches?(error_key)
    else
      include(value.errors).matches?(error_key)
    end
  end
end

RSpec::Matchers.define :be_none do |_expected|
  match(&:none?)
end

RSpec::Matchers.define :be_failed_with do |expected|
  match do |actual|
    actual.failure == expected
  end
end
