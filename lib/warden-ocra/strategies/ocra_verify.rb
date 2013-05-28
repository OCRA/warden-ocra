require_relative 'base_strategy'

module Warden
  module Ocra
    module Strategies
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
    end
  end
end
