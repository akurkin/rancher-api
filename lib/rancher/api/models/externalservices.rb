module Rancher
  module Api
    class Externalservice
      include Her::Model
      include Helpers::Model

      belongs_to :project
    end
  end
end
