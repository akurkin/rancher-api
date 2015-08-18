module Rancher
  module Api
    class JsonParserMiddleware < Faraday::Response::Middleware
      def on_complete(env)
        body = env[:body]

        # Case when resource requested individually doesn't require special
        # handling
        #
        # {
        #   "id": "1ph1",
        #   "type": "machine",
        #   ...
        # }
        #

        # Case when resources are nested inside another 'data' key in response
        # require sepcial handling like the one below
        #
        # {
        #   "type": "collection",
        #   "resourceType": "machine",
        #   "data": [
        #     {
        #       "id": "1ph1",
        #       "type": "machine",
        #       ...
        #     }
        #   ]
        # }
        #

        # If requested resource has type collection - massage data a bit
        # if it's a single resource, just return and render response
        #
        return unless body[:data][:type] == 'collection'

        env[:body] = {
          data: body[:data][:data]
        }
      end
    end
  end
end
