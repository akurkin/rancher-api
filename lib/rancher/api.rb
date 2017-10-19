require 'faraday_middleware'
require 'her'

require 'rancher/api/configuration'
require 'rancher/api/middlewares'
require 'rancher/api/version'
require 'rancher/api/logger'

module Rancher
  module Api
    class << self
      attr_writer :configuration
    end

    def self.setup!
      configure do |_x|
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)

      api = Her::API.setup url: configuration.url do |c|
        # Request
        c.request :json

        c.use Her::Middleware::AcceptJSON
        c.use Faraday::Request::BasicAuthentication, configuration.access_key, configuration.secret_key

        # Response
        c.use Rancher::Api::JsonParserMiddleware
        c.use Her::Middleware::DefaultParseJSON
        c.use Faraday::Response::Logger, ActiveSupport::Logger.new(STDOUT) if configuration.verbose

        # Adapter
        c.use Faraday::Adapter::NetHttpPersistent
      end

      require 'rancher/api/models'
      api
    end
  end
end
