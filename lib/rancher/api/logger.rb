module Rancher
  module Api
    class Logger < ::Logger
      class << self
        def log
          @_logger ||= init
        end

        def init
          logger = new(STDOUT)
          logger.level = ::Logger::INFO
          logger
        end
      end
    end
  end
end
