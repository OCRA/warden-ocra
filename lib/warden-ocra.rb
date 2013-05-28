require 'warden-ocra/version'
require 'warden'
require 'rocra'

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

    module Strategies
      class BaseStrategy < Warden::Strategies::Base
        def user_param
          params[Warden::Ocra::config.param_user_identifier]
        end
      end

      class OcraVerify < BaseStrategy
        def valid?
          user_param && User.has_challenge?(user_param)
        end

        def authenticate!
          user = User.find_by_email! user_param
          response = Rocra.generate(
            Warden::Ocra::config.suite,
            user.shared_secret,
            '',
            user.challenge.to_i.to_s(16),
            '','', ''
          )
          response == params[Warden::Ocra::config.param_response] ?
            success!(user) :
            fail!
        end
      end

      class OcraChallenge < BaseStrategy
        def valid?
          user_param && !User.has_challenge?(user_param)
        end

        def authenticate!
          user = User.generate_challenge! user_param
          env['warden'].set_user(user)
          pass
        end
      end
    end

    Warden::Manager.serialize_into_session { |user| user.id }
    Warden::Manager.serialize_from_session { |id| User.get(id) }

    Warden::Strategies.add :ocra_verify, Strategies::OcraVerify
    Warden::Strategies.add :ocra_challenge, Strategies::OcraChallenge
  end
end
