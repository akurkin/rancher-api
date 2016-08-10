require 'spec_helper'

describe Rancher::Api::Service do
  let(:project) do
    VCR.use_cassette('projects/1a5') do
      Rancher::Api::Project.find('1a5')
    end
  end

  let(:index) do
    VCR.use_cassette('services/index') do
      project.services.to_a
    end
  end

  context '#all' do
    it { expect(index.size).to eq(4) }
    it { expect(index.first).to be_instance_of(Rancher::Api::Service) }
  end

  context '#find - user container - db' do
    let(:service) do
      VCR.use_cassette('services/1s3') do
        Rancher::Api::Service.find('1s3')
      end
    end

    it { expect(service.id).to eq('1s3') }
    it { expect(service.name).to eq('db') }
    it { expect(service.state).to eq('active') }
    it { expect(service.kind).to eq('service') }
    it { expect(service.type).to eq('service') }
    it { expect(service.launchConfig).to include('environment' => { 'MYSQL_ROOT_PASSWORD' => 'root' }) }
    it { expect(service.launchConfig).to include('imageUuid' => 'docker:mysql:latest') }
  end

  context '#find - user container - lb' do
    let(:service) do
      VCR.use_cassette('services/1s9') do
        Rancher::Api::Service.find('1s9')
      end
    end

    it { expect(service.id).to eq('1s9') }
    it { expect(service.name).to eq('lb') }
    it { expect(service.state).to eq('active') }
    it { expect(service.kind).to eq('loadBalancerService') }
    it { expect(service.type).to eq('loadBalancerService') }
  end

  context '#find - user container - rails app' do
    let(:service) do
      VCR.use_cassette('services/1s55') do
        Rancher::Api::Service.find('1s55')
      end
    end

    it { expect(service.id).to eq('1s55') }
    it { expect(service.name).to match('web') }
    it { expect(service.state).to eq('active') }
    it { expect(service.kind).to eq('service') }
    it { expect(service.type).to eq('service') }
    it { expect(service.launchConfig).to include('environment' => { 'RAILS_ENV' => 'production' })}
    it { expect(service.launchConfig).to include('imageUuid' => /hub.howtocookmicroservices.com/)}

    it 'should have an array of command' do
      expect(service.launchConfig).to include('command' => ['bundle', 'exec', 'unicorn', '-p', '3000'])
    end

    it 'should have labels' do
      expect(service.launchConfig).to include(
        'labels' => { 'io.rancher.scheduler.affinity:host_label' => 'branch=master' }
      )
    end
  end

  context 'relationships' do
    context '#instances' do
      let(:service) do
        VCR.use_cassette('services/1s55') do
          Rancher::Api::Service.find('1s55')
        end
      end

      let(:instances) do
        VCR.use_cassette('services/1s55/instances') do
          service.instances.to_a
        end
      end

      it { expect(instances.size).to eq(2) }
      it { expect(instances.first).to be_instance_of(Rancher::Api::Instance) }
    end
  end
end
