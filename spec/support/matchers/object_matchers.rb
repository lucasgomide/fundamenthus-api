# frozen_string_literal: true

module ObjectMatchers
  def match_object(current_result, value)
    return current_result if object.blank?

    (value == object)
  end

  def match_array_of(current_result, value)
    return current_result if object_array_type.blank? || !value.respond_to?(:all?)

    value.all? { |it| it.instance_of?(object_array_type) }
  end

  def match_instance_of(current_result, value)
    return current_result if object_type.blank?

    value.instance_of?(object_type)
  end

  def match_attributes(current_result, value)
    return current_result if object_attributes.blank?

    a_object_with_attributes(object_attributes).matches?(value)
  end
end

RSpec::Matchers.define :a_object_with_attributes do |attrs|
  match do |actual|
    attrs.all? { |attr, value| actual.public_send(attr.to_sym) == value }
  end
end
