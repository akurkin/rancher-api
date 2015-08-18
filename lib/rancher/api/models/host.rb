module Rancher
  module Api
    class Host
      include ::Her::Model

      belongs_to :machine
      has_many :instances
    end
  end
end
