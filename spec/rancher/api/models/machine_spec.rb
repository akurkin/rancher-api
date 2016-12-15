require 'spec_helper'

module Rancher
  module Api

    describe Machine do
      let(:project) do
        VCR.use_cassette('projects/1a5') do
          Project.find('1a5')
        end
      end

      let(:index) do
        VCR.use_cassette('machines/index') do
          Machine.all.to_a
        end
      end

      describe '.active' do
        it { expect(Machine.active.params).to eq(state: 'active') }
      end

      describe 'transitioning' do
        it 'only returns the transitioning machines' do
          index.first.transitioning = 'yes'
          allow(Machine).to receive(:all).and_return(index)
          expect(Machine.transitioning.count).to eq(1)
          expect(Machine.transitioning.first).to be_instance_of(Machine)
        end
      end

      describe '#all' do
        it { expect(index.size).to eq(2) }
        it { expect(index.first).to be_instance_of(Machine) }
      end

      describe '#find' do
        let(:machine) do
          VCR.use_cassette('machines/1ph1') do
            Machine.find('1ph1')
          end
        end

        it { expect(machine.name).to eq('quotes') }
        it { expect(machine.type).to eq('machine') }
        it { expect(machine.kind).to eq('machine') }
        it { expect(machine.state).to eq('active') }
        it { expect(machine.driver).to eq(Machine::DIGITAL_OCEAN) }
      end

      describe '#driver_config' do
        it { expect(index.first.driver_config).to be_instance_of(Machine::DriverConfig) }
      end
    end

  end
end
