module Rancher
  module Api
    class Project
      include Her::Model

      has_many :machines
      has_many :environments
    end
  end
end
