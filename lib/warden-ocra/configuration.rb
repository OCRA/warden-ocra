module Warden
  module Ocra
    class Configuration
      attr_accessor :suite, :param_user_identifier, :param_response,
        :generate_challenge_method, :has_challenge_method,
        :user_finder_method, :user_shared_secret_method,
        :user_challenge_method, :user_class_name

      def initialize
        self.suite = 'OCRA-1:HOTP-SHA1-6:QN08'
        self.param_user_identifier = 'email'
        self.param_response = 'response'
        self.generate_challenge_method = 'generate_challenge!'
        self.has_challenge_method = 'has_challenge?'
        self.user_finder_method = 'find_by_email!'
        self.user_shared_secret_method = 'shared_secret'
        self.user_challenge_method = 'challenge'
        self.user_class_name = 'User'
      end

      def user_class
        Kernel.const_get(user_class_name)
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
