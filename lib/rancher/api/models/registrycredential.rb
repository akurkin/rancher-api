module Rancher
  module Api
    class Registrycredential
      include Her::Model
      include Helpers::Model

      belongs_to :project
      collection_path "projects/:project_id/registrycredentials"
    end
  end
end
