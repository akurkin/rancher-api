module Rancher
  module Api
    class Configuration
      attr_accessor :url
      attr_accessor :access_key
      attr_accessor :secret_key
      attr_accessor :verbose

      def initialize
        @url = ENV['RANCHER_URL']
        @access_key = ENV['RANCHER_ACCESS_KEY']
        @secret_key = ENV['RANCHER_SECRET_KEY']
      end
    end
  end
end
