require 'spec_helper'

describe Rancher::Api::Machine do
  let(:project) do
    VCR.use_cassette('projects/1a5') do
      Rancher::Api::Project.find('1a5')
    end
  end

  let(:index) do
    VCR.use_cassette('machines/index') do
      project.machines.to_a
    end
  end

  context '#all' do
    it { expect(index.size).to eq(2) }
    it { expect(index.first).to be_instance_of(Rancher::Api::Machine) }
  end

  context '#find' do
    let(:machine) do
      VCR.use_cassette('machines/1ph1') do
        Rancher::Api::Machine.find('1ph1')
      end
    end

    it { expect(machine.name).to eq('quotes') }
    it { expect(machine.type).to eq('machine') }
    it { expect(machine.kind).to eq('machine') }
    it { expect(machine.state).to eq('active') }
    it { expect(machine.driver).to eq(Rancher::Api::Machine::DIGITAL_OCEAN) }
  end

  context '#driver_config' do
    it { expect(index.first.driver_config).to be_instance_of(Rancher::Api::Machine::DriverConfig) }
  end
end
