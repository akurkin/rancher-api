module Rancher
  module Api
    class Registry
      include Her::Model
      include Helpers::Model

      belongs_to :project
    end
  end
end
