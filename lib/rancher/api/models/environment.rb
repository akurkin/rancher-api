module Rancher
  module Api
    class Environment
      include ::Her::Model

      belongs_to :project
    end
  end
end
