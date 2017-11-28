module Rancher
  module Api
    class Action
      include ::Her::Model
      include Helpers::Model

      collection_path ':resource_name/:resource_id/?action=:action'
      scope :for_resource, ->(resource_name) { where(resource_name:resource_name) }
      scope :with_id,      ->(resource_id)   { where(resource_id:resource_id)     }
      scope :action,       ->(action_name)   { where(action:action_name)          }
    end
  end
end

