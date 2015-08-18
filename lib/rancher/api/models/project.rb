module Rancher
  module Api
    class Project
      include Her::Model

      has_many :machines
    end
  end
end
