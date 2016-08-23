module Rancher
  module Api
    class Registry
      include Her::Model
      include Helpers::Model

      belongs_to :project
      collection_path "projects/:project_id/registries" # FIXME: fork her gem and pull in fix for this: https://github.com/remiprev/her/issues/224
    end
  end
end
