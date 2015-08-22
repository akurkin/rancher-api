require 'spec_helper'

describe Rancher::Api::Configuration do
  context 'attributes' do
    before do
      subject.url = 'test.test'
      subject.access_key = 'a key'
      subject.secret_key = 'secret'
    end

    it { expect(subject.url).to eq('test.test') }
    it { expect(subject.access_key).to eq('a key') }
    it { expect(subject.secret_key).to eq('secret') }
  end
end
