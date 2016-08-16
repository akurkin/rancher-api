require 'spec_helper'

module Rancher
  module Api
    class Dummy
      include Her::Model
      include Helpers::Model
      attr_accessor :tightness
    end

    module Helpers
      describe Model do
        let(:dummy) { Dummy.new }

        describe '#self_url' do
          it 'returns the self link' do
            expect(dummy).to receive(:links).and_return('self' => 'http://example.com')
            expect(dummy.self_url).to eq('http://example.com')
          end
        end

        describe '#reload' do
          let(:attributes) { OpenStruct.new(attributes: { tightness: 'deluxe' }) }

          it 'reloads the attributes' do
            expect(Dummy).to receive(:find).and_return(attributes)
            dummy.reload
            expect(dummy.tightness).to eq('deluxe')
          end
        end

        describe '#run' do
          let(:test_url) { 'http://example.com/?action=test' }
          context 'action is available' do
            let(:response) { dummy }
            subject { dummy.run(:test) }

            it 'sends a POST request' do
              expect(dummy).to receive(:actions).and_return('test' => test_url)
              expect(Dummy).to receive(:post).with(test_url, {}).and_return(response)
              expect(response).to receive(:type).and_return('Test')
              subject
            end

            context 'response is an error' do
              it 'raises a RancherModelError' do
                expect(dummy).to receive(:actions).and_return('test' => test_url)
                expect(Dummy).to receive(:post).with(test_url, {}).and_return(response)
                expect(response).to receive(:type).and_return('error')
                expect { subject }.to raise_error(Model::RancherModelError)
              end
            end
          end

          context 'action is unavailable' do
            it 'raises a RancherActionNotAvailableError' do
              expect(dummy).to receive(:actions).and_return('test' => test_url).twice
              expect { dummy.run(:bogus)}.to raise_error(Model::RancherActionNotAvailableError)
            end
          end
        end

        describe '#handle_response' do
          subject { dummy.handle_response(response) }

          context 'response is a Her::Collection' do
            let(:response) { Her::Collection.new }

            it 'returns the collection' do
              expect(subject).to eq(response)
            end
          end

          context 'response is a Her::Model' do
            let(:response) { dummy }

            it 'returns the response' do
              expect(dummy).to receive(:type).and_return('dummy')
              expect(subject).to eq(response)
            end

            context 'response.type is "error"' do
              it 'raises a RancherModelError' do
                expect(dummy).to receive(:type).and_return('error')
                expect { subject }.to raise_error(Model::RancherModelError)
              end
            end

            context 'response is nil' do
              it 'raises a RancherModelError' do
                expect { dummy.handle_response(nil) }.to raise_error(Model::RancherModelError)

              end
            end
          end
        end

        describe '#wait_for_state' do
          subject { dummy.wait_for_state(:active) }

          context 'no timeout' do
            it 'loops until desired state is reached' do
              allow(dummy).to receive(:sleep)
              expect(dummy).to receive(:reload).at_least(1)
              expect(dummy).to receive(:state).and_return('inactive', 'activating', 'active')
              subject
            end
          end
        end
      end
    end
  end
end
