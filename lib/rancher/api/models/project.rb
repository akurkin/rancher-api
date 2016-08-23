# These are 'Environments' in the UI
module Rancher
  module Api
    class Project
      include Her::Model
      include Helpers::Model

      has_many :machines
      has_many :environments
      has_many :services
      has_many :apikeys
      has_many :registries
      has_many :registrationtokens

      class << self
        def find_by_name(name:)
          # filters not working for name yet, so using select
          all.reject { |e| e.state.eql?('purged') }.select { |e| e.name.eql?(name) }
        end
      end
    end
  end
end
