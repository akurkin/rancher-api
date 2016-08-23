module Rancher
  module Api
    class Registrationtoken
      include Her::Model
      include Helpers::Model

      belongs_to :project
    end
  end
end
