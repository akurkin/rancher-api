module Rancher
  module Api
    class Host
      include Her::Model
      include Helpers::Model

      belongs_to :machine
      has_many :instances
      has_many :ipaddresses
    end
  end
end
