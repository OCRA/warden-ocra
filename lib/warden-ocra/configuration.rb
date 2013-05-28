module Warden
  module Ocra
    class Configuration
      attr_accessor :suite, :param_user_identifier, :param_response

      def initialize
        self.suite = 'OCRA-1:HOTP-SHA1-6:QN08'
        self.param_user_identifier = 'email'
        self.param_response = 'response'
      end
    end

    def self.config
      @@config ||= Configuration.new
    end

    def self.configure
      yield config
    end
  end
end
