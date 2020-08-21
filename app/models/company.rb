class Company
  include Mongoid::Document
  field :ticker_symbol, type: String
  field :name, type: String
  field :segment, type: String

  validates :ticker_symbol, :name, presence: true

  has_many :earnings
  has_many :fundamentals

  index({ ticker_symbol: 1 }, { unique: true })
  index({ name: 1 })
  index({ segment: 1 })
end
