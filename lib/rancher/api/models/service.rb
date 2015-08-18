module Rancher
  module Api
    class Service
      include ::Her::Model

      belongs_to :project
    end
  end
end
