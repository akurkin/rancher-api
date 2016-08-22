module Rancher
  module Api
    class Registrycredential
      include Her::Model
      include Helpers::Model

      belongs_to :project
    end
  end
end
