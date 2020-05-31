require 'net/http'
require 'uri'

module Viberroo
  class Bot
    def initialize(token: nil, response: nil, callback: nil)
      warn 'DEPRECATION WARNING: callback Viberroo::Bot.new `callback:` parameter will be renamed to `response:` in next minor release.' if callback

      Viberroo.configure

      @headers = {
        'X-Viber-Auth-Token': token || Viberroo.config.auth_token,
        'Content-Type': 'application/json'
      }
      @response = response
      @callback = callback
    end

    def set_webhook(url:, event_types: nil, send_name: nil, send_photo: nil)
      request(URL::WEBHOOK, url: url, event_types: event_types,
              send_name: send_name, send_photo: send_photo)
    end

    def set_webhook!(url:, event_types: nil, send_name: nil, send_photo: nil)
      parse set_webhook(url: url, event_types: event_types,
                        send_name: send_name, send_photo: send_photo)
    end

    def remove_webhook
      request(URL::WEBHOOK, url: '')
    end

    def remove_webhook!
      parse remove_webhook
    end

    def send(message:, keyboard: {})
      request(URL::MESSAGE,
              { receiver: @response&.user_id || @callback&.user_id }.merge(message).merge(keyboard))
    end

    def send!(message:, keyboard: {})
      parse self.send(message: message, keyboard: keyboard)
    end

    def broadcast(message:, to:)
      request(URL::BROADCAST_MESSAGE, message.merge(broadcast_list: to))
    end

    def broadcast!(message:, to:)
      parse broadcast(message: message, to: to)
    end

    def get_account_info
      request(URL::GET_ACCOUNT_INFO)
    end

    def get_account_info!
      parse get_account_info
    end

    def get_user_details(id:)
      request(URL::GET_USER_DETAILS, id: id)
    end

    def get_user_details!(id:)
      parse get_user_details(id: id)
    end

    def get_online(ids:)
      request(URL::GET_ONLINE, ids: ids)
    end

    def get_online!(ids:)
      parse get_online(ids: ids)
    end

    private

    def request(url, params = {})
      uri = URI(url)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Post.new(uri, @headers)
        request.body = compact(params).to_json

        http.request(request)
      end

      Viberroo.config.logger&.info("##{caller_name} -- #{response.body}")

      Viberroo.config.parse_response_body ? JSON.parse(response.body) : response
    end

    def parse(request)
      warn 'DEPRECATION WARNING: Viberroo::Bot bang methods will be dropped on next minor release. Use Viberroo.config.parse_response_body.'
      JSON.parse(request.body)
    end

    def compact(params)
      params.delete_if { |_, v| v.nil? }
    end

    def caller_name
      caller[1][/`.*'/][1..-2]
    end
  end
end
