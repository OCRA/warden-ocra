require_relative 'base_strategy'

module Warden
  module Ocra
    module Strategies
      class OcraChallenge < BaseStrategy
        def valid?
          !has_challenge?
        end

        def authenticate!
          user = generate_challenge
          env['warden'].set_user(user)
          pass
        end
      end
    end
  end
end
