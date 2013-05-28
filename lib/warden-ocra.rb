require 'warden-ocra/version'
require 'warden'
require 'rocra'

SUITE = 'OCRA-1:HOTP-SHA1-6:QN08'

module Warden
  module Ocra
    class Configuration
      def initialize
      end
    end

    def self.config
      @@config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    module Strategies
      class OcraVerify < Warden::Strategies::Base
        def valid?
          params["email"] && User.has_challenge?(params["email"])
        end

        def authenticate!
          user = User.find_by_email!(params["email"])
          challenge_hex = user.challenge.to_i.to_s(16)
          response = Rocra.generate(
            SUITE, user.shared_secret, '', challenge_hex, '', '', '')
            params_response = params["response"]
            response == params_response ? success!(user) : fail!("Cannot log in")
        end
      end

      class OcraChallenge < Warden::Strategies::Base
        def valid?
          params["email"] && !User.has_challenge?(params["email"])
        end

        def authenticate!
          u = User.generate_challenge! params["email"]
          env['warden'].set_user(u)
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
