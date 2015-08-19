module Rancher
  module Api
    class Service
      include ::Her::Model

      belongs_to :project
      has_many :instances
    end
  end
end
