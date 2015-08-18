module Rancher
  module Api
    class Host
      include ::Her::Model
      belongs_to :machine
    end
  end
end
