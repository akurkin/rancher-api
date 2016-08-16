require 'eventmachine'

module Rancher
  module Api
    module Helpers
      module Model
        class RancherWaitTimeOutError < StandardError; end
        class RancherModelError < StandardError; end
        class RancherActionNotAvailableError < StandardError; end

        TIMEOUT_LIMIT = 900

        def self_url
          links['self']
        end

        def reload
          assign_attributes(self.class.find(id).attributes)
        end

        def run(action, data: {})
          url = actions[action.to_s]
          raise RancherActionNotAvailableError, "Available actions: '#{actions.inspect}'" if url.blank?
          handle_response(self.class.post(url, data))
        end

        def handle_response(response)
          case response
          when Her::Collection
            response
          when Her::Model
            raise RancherModelError, response.inspect if response.type.eql?('error')
            response
          else
            raise RancherModelError, response.inspect
          end
        end

        def wait_for_state(desired_state)
          EM.run do
            EM.add_timer(TIMEOUT_LIMIT) do
              raise RancherWaitTimeOutError, "Timeout while waiting for transition to: #{desired_state}"
            end
            EM.tick_loop do
              reload
              current_state = state
              if current_state.eql?(desired_state.to_s)
                Logger.log.info "state changed from: #{current_state} => #{desired_state}"
                EM.stop
              else
                Logger.log.info "waiting for state change: #{current_state} => #{desired_state}"
                sleep(1)
              end
            end
          end
        end
      end
    end
  end
end
