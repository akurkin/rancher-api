module Rancher
  module Api
    class Environment
      include ::Her::Model

      belongs_to :project
      has_many :services
    end
  end
end
