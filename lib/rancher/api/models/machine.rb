require 'rancher/api/models/machine/driver_config'

module Rancher
  module Api
    class Machine
      DIGITAL_OCEAN = 'digitalocean'
      VMWARE_VSPHERE = 'vmwarevsphere'

      include Her::Model

      attributes :name, :state, :amazonec2Config, :azureConfig, :description,
                 :digitaloceanConfig, :driver, :exoscaleConfig, :externalId,
                 :labels, :openstackConfig, :packetConfig, :rackspaceConfig,
                 :removed, :softlayerConfig, :virtualboxConfig,
                 :vmwarevcloudairConfig, :vmwarevsphereConfig

      has_many :hosts

      def driver_config
        case driver
        when DIGITAL_OCEAN, VMWARE_VSPHERE
          DriverConfig.new(attributes["#{driver}Config"])
        end
      end

      def driver_config=(dc)
        case driver
        when DIGITAL_OCEAN, VMWARE_VSPHERE
          attributes["#{driver}Config"] = dc.attributes
        end
      end
    end
  end
end
