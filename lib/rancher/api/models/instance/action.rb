require 'faye/websocket'
require 'eventmachine'

module Rancher
  module Api
    class Instance
      # Few possible actions are:
      #   - execute shell command
      #   - render logs
      #   - restart
      #
      class Action
        include Her::Model

        attributes :token, :url, :response

        def run!
          uri = URI.parse(url)
          uri.userinfo = "#{Rancher::Api.configuration.access_key}:#{Rancher::Api.configuration.secret_key}"
          uri.query = "token=#{token}"

          self.response = []

          EM.run do
            # 15 seconds timeout in case of slow operation
            #
            EM.add_timer(15) do
              EM.stop
            end

            ws = Faye::WebSocket::Client.new(uri.to_s)

            ws.on :message do |event|
              self.response << Base64.decode64(event.data)
            end

            ws.on :close do |event|
              ws = nil
              EM.stop
            end
          end

          self.response = self.response.join

          self
        end
      end
    end
  end
end
