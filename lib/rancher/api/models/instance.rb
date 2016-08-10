require 'rancher/api/models/instance/action'

module Rancher
  module Api
    #
    # instance usually container
    #
    class Instance
      include ::Her::Model
      include Helpers::Model

      belongs_to :host

      def container?
        type == 'container'
      end

      #
      # Actions: execute, logs, restart, setlabels, stop, update
      #

      #
      # Execute works like this:
      #   - send request with command (array of strings)
      #   - in response you get WebSocket URL and token
      #   - connect to container using WebSocket and send token as parameter
      #   - get response and exit websocket connection
      #

      # HTTP/1.1 POST /v1/projects/1a5/containers/1i382/?action=execute
      # Host: 188.166.70.58:8080
      # Accept: application/json
      # Content-Type: application/json
      # Content-Length: 112

      # {
      #   "attachStdin": true,
      #   "attachStdout": true,
      #   "command": [
      #     "rake",
      #     "db:create",
      #     "db:schema:load",
      #     "db:seed"
      #   ],
      #   "tty": true
      # }

      def execute(command)
        url = actions['execute']

        data = {
          'attachStdin' => true,
          'attachStdout' => true,
          'command' => command,
          'tty' => true
        }

        action = Action.post(url, data)
        action.run!
      end

      def logs(lines = 20)
        url = actions['logs']
        data = {
          'follow' => false,
          'lines' => lines
        }

        action = Action.post(url, data)
        action.run!
      end
    end
  end
end
