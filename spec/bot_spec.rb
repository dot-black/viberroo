require 'spec_helper'

RSpec.describe Viberroo::Bot do
  let(:token) { '1234567890' }
  let(:headers) { { 'X-Viber-Auth-Token': token } }
  let(:api_response) { { body: { status: 0, status_message: 'ok' }.to_json } }
  let(:response) { Viberroo::Response.new(event: 'message', sender: { id: '01234=' }) }
  let(:bot) { Viberroo::Bot.new(token: token, response: response) }

  describe '#send_message' do
    subject { bot.send_message(message, keyboard: keyboard) }

    let(:message) do
      {
        text: 'hello',
        event: 'message',
        sender: { id: '1234=' },
        receiver: response.user_id
      }
    end

    context 'when keyboard does not contain inputs' do
      let(:keyboard) { {} }

      it 'does not contain :min_api_version attr in the params root' do
        expect(bot).to receive(:request).with(
          Viberroo::URL::MESSAGE,
          { receiver: response.user_id }.merge(message)
        )
        subject
      end
    end

    context 'when keyboard contain single input with api version' do
      let(:button)          { Viberroo::Input.share_phone_button({}) }
      let(:keyboard)        { Viberroo::Input.keyboard(Buttons: [button]) }
      let(:min_api_version) { button[:min_api_version] }

      it 'sets correct :min_api_version attr in the params root' do
        expect(bot).to receive(:request).with(
          Viberroo::URL::MESSAGE,
          { receiver: response.user_id }.merge(message, keyboard, min_api_version: min_api_version)
        )
        subject
      end
    end

    context 'when keyboard contain single input with api version but min_api-version was set before' do
      let(:min_api_version) { 7 }
      let(:message)         { { min_api_version: min_api_version } }
      let(:button)          { Viberroo::Input.share_phone_button({}) }
      let(:keyboard)        { Viberroo::Input.keyboard(Buttons: [button]) }

      it 'sets correct :min_api_version attr in the params root' do
        expect(bot).to receive(:request).with(
          Viberroo::URL::MESSAGE,
          { receiver: response.user_id }.merge(message, keyboard, min_api_version: min_api_version)
        )
        subject
      end
    end

    context 'when keyboard contain multiple inputs one of which has no api versions' do
      let(:button_one)      { Viberroo::Input.share_phone_button({}) }
      let(:button_two)      { Viberroo::Input.reply_button({}) }
      let(:keyboard)        { Viberroo::Input.keyboard(Buttons: [button_one, button_two]) }
      let(:min_api_version) { button_one[:min_api_version] }

      it 'sets correct :min_api_version attr in the params root' do
        expect(bot).to receive(:request).with(
          Viberroo::URL::MESSAGE,
          { receiver: response.user_id }.merge(message, keyboard, min_api_version: min_api_version)
        )
        subject
      end
    end

    context 'when keyboard contain multiple inputs with different api versions' do
      let(:button_one)      { Viberroo::Input.share_phone_button({ min_api_version: 3 }) }
      let(:button_two)      { Viberroo::Input.reply_button({ min_api_version: 7 }) }
      let(:keyboard)        { Viberroo::Input.keyboard(Buttons: [button_one, button_two]) }
      let(:min_api_version) { button_two[:min_api_version] }

      it 'sets correct :min_api_version attr in the params root' do
        expect(bot).to receive(:request).with(
          Viberroo::URL::MESSAGE,
          { receiver: response.user_id }.merge(message, keyboard, min_api_version: min_api_version)
        )
        subject
      end
    end
  end

  describe 'setting a webhook' do
    let(:bot) { Viberroo::Bot.new(token: token) }
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
      subject { bot.set_webhook(**body) }

      it 'makes a request with correct url, body and headers' do
        expect(request).to have_been_made.once
      end
    end
  end

  describe 'removing a webhook' do
    let(:bot) { Viberroo::Bot.new(token: token) }
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
  end

  describe 'sending a message' do
    let!(:message) do
      {
        text: 'hello',
        event: 'message',
        sender: { id: '1234=' },
        receiver: response.user_id
      }
    end
    let!(:request) do
      stub_request(:post, Viberroo::URL::MESSAGE)
        .with(body: message, headers: headers)
        .and_return(api_response)
    end

    before { subject }

    context 'with #send_message' do
      subject { bot.send_message(message) }

      it 'makes a request with correct url, body and headers' do
        expect(request).to have_been_made.once
      end
    end
  end

  describe 'broadcasting message' do
    let!(:to) { %w[1234= 4321= 3921=] }
    let!(:message) { { text: 'hello', event: 'message' } }
    let!(:request) do
      stub_request(:post, Viberroo::URL::BROADCAST_MESSAGE)
        .with(headers: headers, body: message.merge(broadcast_list: to))
        .and_return(api_response)
    end

    before { subject }

    context 'with #broadcast' do
      subject { bot.broadcast(message: message, to: to) }

      it 'makes a request with correct url, body and headers' do
        expect(request).to have_been_made.once
      end
    end
  end

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
      subject { bot.get_user_details(**params) }

      it 'makes a request with correct url, body and headers' do
        expect(request).to have_been_made.once
      end
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
      subject { bot.get_online(**params) }

      it 'makes a request with correct url, body and headers' do
        expect(request).to have_been_made.once
      end
    end
  end
end
