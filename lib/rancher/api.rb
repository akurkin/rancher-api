require 'her'

require 'rancher/api/configuration'
require 'rancher/api/middlewares'
require 'rancher/api/version'

module Rancher
  module Api
    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)

      Her::API.setup url: configuration.url do |c|
        # Request
        c.use Her::Middleware::AcceptJSON
        c.use Faraday::Request::UrlEncoded
        c.use Faraday::Request::BasicAuthentication, configuration.access_key, configuration.secret_key

        # Response
        c.use Rancher::Api::JsonParserMiddleware
        c.use Her::Middleware::DefaultParseJSON

        # Adapter
        c.use Faraday::Adapter::NetHttp
      end

      require 'rancher/api/models'
    end
  end
end
