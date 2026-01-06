# frozen_string_literal: true

require 'textris/delivery/base'

module Textris
  module Delivery
    class Ovh < Base
      # Configuration module for OVH SMS API credentials.
      #
      # This module provides accessors for the OVH API authentication
      # parameters. Values can be set directly or fall back to environment
      # variables.
      #
      # @example Configuration via environment variables
      #   # Set these in your environment:
      #   # OVH_SMS_SERVICE_NAME=sms-xxxxx
      #   # OVH_SMS_APPLICATION_KEY=your_key
      #   # OVH_SMS_APPLICATION_SECRET=your_secret
      #   # OVH_SMS_CONSUMER_KEY=your_consumer_key
      #
      # @example Configuration via block
      #   Textris::Delivery::Ovh.configure do |config|
      #     config.service_name = 'sms-xxxxx'
      #     config.application_key = 'your_key'
      #     config.application_secret = 'your_secret'
      #     config.consumer_key = 'your_consumer_key'
      #   end
      module Configuration
        # Configures the module with a block.
        #
        # @yield [self] The Configuration module for setting parameters
        # @return [void]
        def configure
          yield self
        end

        # Returns the OVH SMS service name.
        #
        # @return [String] The service name from config or ENV['OVH_SMS_SERVICE_NAME']
        def service_name
          @service_name || ENV['OVH_SMS_SERVICE_NAME']
        end

        # Sets the OVH SMS service name.
        #
        # @param value [String] The service name (e.g., 'sms-xxxxx')
        # @return [String] The assigned value
        def service_name=(value)
          @service_name = value
        end

        # Returns the OVH application key.
        #
        # @return [String] The application key from config or ENV['OVH_SMS_APPLICATION_KEY']
        def application_key
          @application_key || ENV['OVH_SMS_APPLICATION_KEY']
        end

        # Sets the OVH application key.
        #
        # @param value [String] The application key
        # @return [String] The assigned value
        def application_key=(value)
          @application_key = value
        end

        # Returns the OVH application secret.
        #
        # @return [String] The application secret from config or ENV['OVH_SMS_APPLICATION_SECRET']
        def application_secret
          @application_secret || ENV['OVH_SMS_APPLICATION_SECRET']
        end

        # Sets the OVH application secret.
        #
        # @param value [String] The application secret
        # @return [String] The assigned value
        def application_secret=(value)
          @application_secret = value
        end

        # Returns the OVH consumer key.
        #
        # @return [String] The consumer key from config or ENV['OVH_SMS_CONSUMER_KEY']
        def consumer_key
          @consumer_key || ENV['OVH_SMS_CONSUMER_KEY']
        end

        # Sets the OVH consumer key.
        #
        # @param value [String] The consumer key
        # @return [String] The assigned value
        def consumer_key=(value)
          @consumer_key = value
        end
      end
    end
  end
end
