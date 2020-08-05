# frozen_string_literal: true

module SerializerMatchers
  extend RSpec::Matchers::DSL

  RSpec::Matchers.define :have_attributes do |expected|
    match do |actual|
      contain_exactly(*actual.attributes.keys).matches?(expected)
    end
  end

  RSpec::Matchers.define :have_many do |expected|
    define_method :match_association do
      @associations.include?(expected)
    end

    define_method :match_has_many do |result|
      result && @associations[expected].instance_of?(ActiveModel::Serializer::HasManyReflection)
    end

    define_method :match_serializer do |result|
      return result if @serializer.blank?

      result && @associations[expected].options[:serializer] == @serializer
    end

    match do |actual|
      @associations = actual._reflections

      match_association
        .then(&method(:match_has_many))
        .then(&method(:match_serializer))
    end

    chain :with_serializer, :serializer
  end
end

RSpec.configure do |config|
  config.include SerializerMatchers, type: :serializer
end
