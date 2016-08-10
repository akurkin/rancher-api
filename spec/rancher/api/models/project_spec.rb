require 'spec_helper'

describe Rancher::Api::Project do
  let(:index) do
    VCR.use_cassette('projects/index') do
      subject.class.all.to_a.sort_by(&:name)
    end
  end

  context '#all' do
    it { expect(index.size).to eq(1) }
    it { expect(index.first).to be_instance_of(Rancher::Api::Project) }
  end

  context 'find' do
    let(:project) do
      VCR.use_cassette('projects/1a5') do
        Rancher::Api::Project.find('1a5')
      end
    end

    it { expect(project).to be_instance_of(Rancher::Api::Project) }
    it { expect(project.name).to eq('Default') }
    it { expect(project.state).to eq('active') }
    it { expect(project.description).to be_nil }
    it { expect(project.kind).to eq('project') }
  end

  context 'relationships' do
    let(:project) { index.first }

    context '#machines' do
      let(:machines) do
        VCR.use_cassette('projects/machines') do
          project.machines.to_a
        end
      end

      it { expect(machines.size).to eq(2) }
      it { expect(machines.first).to be_instance_of(Rancher::Api::Machine) }
    end

    context '#environments' do
      let(:environments) do
        VCR.use_cassette('projects/environments') do
          project.environments.to_a
        end
      end

      it { expect(environments.size).to eq(2) } # hub and quotes
      it { expect(environments.first).to be_instance_of(Rancher::Api::Environment) }
    end

    context '#services' do
      let(:services) do
        VCR.use_cassette('projects/services') do
          project.services.to_a
        end
      end

      it { expect(services.size).to eq(4) } # hub, web, db, lb
      it { expect(services.first).to be_instance_of(Rancher::Api::Service) }
    end
  end
end
