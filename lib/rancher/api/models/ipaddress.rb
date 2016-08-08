module Rancher
  module Api
    class Ipaddress
      include Her::Model
      include Helpers::Model

      attributes :name, :state, :address
    end
  end
end
