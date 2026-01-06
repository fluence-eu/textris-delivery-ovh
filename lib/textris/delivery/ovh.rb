# frozen_string_literal: true

require_relative 'ovh/configuration'

module Textris
  module Delivery
    # Delivery class for sending SMS via OVH API.
    #
    # This class integrates with the Textris gem to provide SMS delivery
    # through OVH's SMS API. It handles authentication, request signing,
    # and message delivery.
    #
    # @example Configuration via initializer
    #   # config/initializers/textris_ovh.rb
    #   Textris::Delivery::Ovh.configure do |config|
    #     config.service_name = 'sms-xxxxx'
    #     config.application_key = 'your_app_key'
    #     config.application_secret = 'your_app_secret'
    #     config.consumer_key = 'your_consumer_key'
    #   end
    #
    # @example Configuration via environment variables
    #   # OVH_SMS_SERVICE_NAME=sms-xxxxx
    #   # OVH_SMS_APPLICATION_KEY=your_app_key
    #   # OVH_SMS_APPLICATION_SECRET=your_app_secret
    #   # OVH_SMS_CONSUMER_KEY=your_consumer_key
    #
    # @see https://api.ovh.com/console/#/sms OVH SMS API Documentation
    class Ovh < Base
      include Configuration

      require 'digest'
      require 'faraday'
      require 'json'

      # @return [String] Base URL for OVH European API
      API_URL = 'https://eu.api.ovh.com'

      # @return [String] API version used for requests
      VERSION = '1.0'

      # Delivers an SMS message to the specified phone number.
      #
      # @param to_phone [String] The recipient's phone number
      # @return [Hash] The parsed JSON response from the OVH API
      def deliver(to_phone)
        send_sms(
          message: message.content,
          receivers: [Textris::PhoneFormatter.format(to_phone)],
          sender: Textris::PhoneFormatter.format(message.from),
          noStopClause: true
        )
      end

      private

      # Returns the Faraday HTTP connection instance.
      #
      # @return [Faraday::Connection] Memoized connection to OVH API
      def conn
        @conn ||= Faraday.new(url: API_URL)
      end

      # Executes an authenticated API request to OVH.
      #
      # Builds the request with proper OVH authentication headers including
      # the cryptographic signature required by the API.
      #
      # @param path [String] The API endpoint path (without version prefix)
      # @param params [Hash] Request parameters
      # @option params [Symbol] :method The HTTP method (:get, :post, etc.)
      # @option params [Hash] :query The request body to send as JSON
      # @return [Hash] The parsed JSON response
      def query(path, **params)
        query = params[:query].to_json
        signature, timestamp = signature_timestamp(
          method: params[:method].to_s.upcase,
          url: path,
          query: query
        )
        headers = {
          'X-Ovh-Application' => application_key,
          'X-Ovh-Consumer' => consumer_key,
          'X-Ovh-Signature' => signature,
          'X-Ovh-Timestamp' => timestamp,
          'Content-Type' => 'application/json'
        }
        response = conn.run_request(params[:method], "/#{VERSION}/#{path}", query, headers)

        JSON.parse(response.body)
      end

      # Sends an SMS message via the OVH API.
      #
      # @param message [Hash] The SMS parameters
      # @option message [String] :message The SMS content
      # @option message [Array<String>] :receivers List of recipient phone numbers
      # @option message [String] :sender The sender phone number or name
      # @option message [Boolean] :noStopClause Whether to omit STOP clause
      # @return [Hash] The parsed JSON response from OVH
      def send_sms(message = {})
        query("sms/#{service_name}/jobs", method: :post, query: message)
      end

      # Generates the OVH API signature and retrieves the server timestamp.
      #
      # The signature is computed as SHA1 hash of concatenated values:
      # application_secret + consumer_key + method + url + body + timestamp
      #
      # @param params [Hash] Parameters for signature generation
      # @option params [String] :method The HTTP method (uppercase)
      # @option params [String] :url The request URL path
      # @option params [String] :query The JSON-encoded request body
      # @return [Array<String, String>] The signature and timestamp
      def signature_timestamp(params = {})
        timestamp = conn.get("/#{VERSION}/auth/time").body
        pre_hash_signature = [
          application_secret,
          consumer_key,
          params[:method],
          "#{API_URL}/#{VERSION}/#{params[:url]}",
          params[:query],
          timestamp
        ].join('+')
        post_hash_signature = "$1$#{Digest::SHA1.hexdigest(pre_hash_signature)}"

        [post_hash_signature, timestamp]
      end
    end
  end
end
