require 'spec_helper'

module Rancher
  module Api
    describe Logger do
      describe '.log' do
        subject { Logger.log }

        it 'returns the logger' do
          expect(subject).to be_a(Logger)
        end
      end
    end
  end
end
