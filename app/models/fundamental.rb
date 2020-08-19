class Fundamental
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :source, type: String
  field :data, type: Hash

  belongs_to :company

  validates :source, :data, presence: true

  index({ source: 1 })
end
