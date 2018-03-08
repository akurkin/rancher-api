module Rancher
  module Api
    class Auditlog
      include Her::Model
      include Helpers::Model

      attributes :resourceId
    end
  end
end
