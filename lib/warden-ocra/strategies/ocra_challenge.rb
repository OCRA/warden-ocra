require_relative 'base_strategy'

module Warden
  module Ocra
    module Strategies
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
  end
end
