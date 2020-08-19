RSpec.configure do |config|
  config.before(:each) { Mongoid.purge! }
end
