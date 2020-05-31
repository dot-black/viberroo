require 'spec_helper'

RSpec.describe Viberroo::Bot do
  let(:token) { '1234567890' }
  let(:headers) { { 'X-Viber-Auth-Token': token } }
  let(:api_response) { { body: { status: 0, status_message: 'ok' }.to_json } }
  let(:bot) { Viberroo::Bot.new(token: token, response: callback_response) }

  context 'with deprecated Response.init' do
    let(:callback_response) { Viberroo::Response.init(event: 'message', sender: { id: '01234=' }) }
    describe 'setting a webhook' do
      let!(:body) do
        { url: 'http://my.host.com', event_types: %w[conversation_started] }
      end
      let!(:request) do
        stub_request(:post, Viberroo::URL::WEBHOOK)
          .with(body: body, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #set_webhook' do
        subject { bot.set_webhook(body) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #set_webhook!' do
        subject { bot.set_webhook!(body) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'removing a webhook' do
      let!(:request) do
        stub_request(:post, Viberroo::URL::WEBHOOK)
          .with(headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #remove_webhook' do
        subject { bot.remove_webhook }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #remove_webhook!' do
        subject { bot.remove_webhook! }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'sending a message' do
      let!(:message) do
        {
          text: 'hello',
          event: 'message',
          sender: { id: '1234=' },
          receiver: callback_response.user_id
        }
      end
      let!(:request) do
        stub_request(:post, Viberroo::URL::MESSAGE)
          .with(body: message, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #send' do
        subject { bot.send(message: message) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #send!' do
        subject { bot.send!(message: message) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe '#broadcast message'

    describe 'getting account info' do
      let!(:request) do
        stub_request(:post, Viberroo::URL::GET_ACCOUNT_INFO)
          .with(headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #get_account_info' do
        subject { bot.get_account_info }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #get_account_info!' do
        subject { bot.get_account_info! }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'getting user details' do
      let!(:params) { { id: '1234567890=' } }
      let!(:request) do
        stub_request(:post, Viberroo::URL::GET_USER_DETAILS)
          .with(body: params, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #get_user_details' do
        subject { bot.get_user_details(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #get_user_details!' do
        subject { bot.get_user_details!(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'getting online' do
      let!(:params) { { ids: %w[1234= 2532= 8587=] } }
      let!(:request) do
        stub_request(:post, Viberroo::URL::GET_ONLINE)
          .with(body: params, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #get_online' do
        subject { bot.get_online(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #get_online!' do
        subject { bot.get_online!(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end
  end

  context 'with new Callback class' do
    let(:callback_response) { Viberroo::Callback.new(event: 'message', sender: { id: '01234=' }) }
    describe 'setting a webhook' do
      let!(:body) do
        { url: 'http://my.host.com', event_types: %w[conversation_started] }
      end
      let!(:request) do
        stub_request(:post, Viberroo::URL::WEBHOOK)
          .with(body: body, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #set_webhook' do
        subject { bot.set_webhook(body) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #set_webhook!' do
        subject { bot.set_webhook!(body) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'removing a webhook' do
      let!(:request) do
        stub_request(:post, Viberroo::URL::WEBHOOK)
          .with(headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #remove_webhook' do
        subject { bot.remove_webhook }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #remove_webhook!' do
        subject { bot.remove_webhook! }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'sending a message' do
      let!(:message) do
        {
          text: 'hello',
          event: 'message',
          sender: { id: '1234=' },
          receiver: callback_response.user_id
        }
      end
      let!(:request) do
        stub_request(:post, Viberroo::URL::MESSAGE)
          .with(body: message, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #send' do
        subject { bot.send(message: message) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #send!' do
        subject { bot.send!(message: message) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe '#broadcast message'

    describe 'getting account info' do
      let!(:request) do
        stub_request(:post, Viberroo::URL::GET_ACCOUNT_INFO)
          .with(headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #get_account_info' do
        subject { bot.get_account_info }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #get_account_info!' do
        subject { bot.get_account_info! }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'getting user details' do
      let!(:params) { { id: '1234567890=' } }
      let!(:request) do
        stub_request(:post, Viberroo::URL::GET_USER_DETAILS)
          .with(body: params, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #get_user_details' do
        subject { bot.get_user_details(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #get_user_details!' do
        subject { bot.get_user_details!(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end

    describe 'getting online' do
      let!(:params) { { ids: %w[1234= 2532= 8587=] } }
      let!(:request) do
        stub_request(:post, Viberroo::URL::GET_ONLINE)
          .with(body: params, headers: headers)
          .and_return(api_response)
      end

      before { subject }

      context 'with #get_online' do
        subject { bot.get_online(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end
      end

      context 'with #get_online!' do
        subject { bot.get_online!(params) }

        it 'makes a request with correct url, body and headers' do
          expect(request).to have_been_made.once
        end

        it { is_expected.to be_a(Hash) }
      end
    end
  end
end
