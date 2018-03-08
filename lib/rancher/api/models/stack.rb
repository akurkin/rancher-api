module Rancher
  module Api
    class Stack
      include Her::Model
      include Helpers::Model

      belongs_to :project, foreign_key: :accountId
      has_many :services
    end
  end
end
