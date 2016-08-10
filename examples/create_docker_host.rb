# Objectives of this script is to:
# - check if docker host for branch exists (using labels)
# - create docker host via Rancher if it doesn't exist
#
require 'rancher/api'

BRANCH = ENV['CIRCLE_BRANCH']
DIGITAL_OCEAN_ACCESS_TOKEN = 'xxx'.freeze

Rancher::Api.configure do |config|
  config.url = "http://#{ENV['RANCHER_HOST']}/v1/"
  config.access_key = ENV['RANCHER_ACCESS_KEY']
  config.secret_key = ENV['RANCHER_SECRET_KEY']
end

project = Rancher::Api::Project.all.to_a.first
all_machines = project.machines

# 1. check if docker host exists, label branch must be equal to current branch
machine = all_machines.select { |x| x.labels['branch'] == BRANCH }.first

# 2. docker host doesn't exist, let's create one
unless machine
  machine = project.machines.build
  machine.name = 'app-' + BRANCH
  machine.driver = Rancher::Api::Machine::DIGITAL_OCEAN
  machine.driver_config = Rancher::Api::Machine::DriverConfig.new(
    accessToken: DIGITAL_OCEAN_ACCESS_TOKEN,
    size: '1gb',
    region: 'ams3',
    image: 'ubuntu-14-04-x64'
  )

  machine.labels = {
    branch: BRANCH
  }

  machine.save

  puts "CREATING NEW MACHINE: #{machine.id} - #{machine.name}"
  puts 'Set timeout to 5 minutes'

  # Wait until machine is active, on Digital Ocean claim to be 55 seconds
  #
  Timeout.timeout(300) do
    i = 45
    puts "Waiting #{i} seconds..."
    sleep i

    while machine.transitioning == 'yes'
      wait_time = 5
      i += wait_time

      puts machine.transitioningMessage
      puts "Waiting total: #{i} seconds ..."

      sleep wait_time

      machine = Rancher::Api::Machine.find(machine.id)
    end
  end
end
