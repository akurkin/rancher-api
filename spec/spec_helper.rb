$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'

require 'rancher/api'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/'
  c.hook_into :webmock
end

Rancher::Api.configure do |config|
  config.url = 'http://192.168.99.100:8080/v1/projects/1a5'
  config.access_key = 'XXX'
  config.secret_key = 'YYY'
end

RSpec.configure do |_config|
end
