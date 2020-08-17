source 'https://rubygems.org'
source 'https://rubygems.pkg.github.com/lucasgomide'

ruby '2.6.1'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'redis'
gem 'sidekiq'
gem 'curb'
gem 'dry-rails'
gem 'dry-monads'
gem 'google-drive'
gem 'fundamenthus-client', '<1'
gem 'sidekiq-scheduler'

group :development, :test do
  gem 'pry-byebug'
end

group :development do
  gem 'rubocop-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'webmock'
  gem 'factory_bot_rails'
end
