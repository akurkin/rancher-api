module Rancher
  module Api
    class Ipaddress
      include Her::Model

      attributes :name, :state, :address
    end
  end
end
