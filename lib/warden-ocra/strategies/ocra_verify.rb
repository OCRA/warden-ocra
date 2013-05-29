require_relative 'base_strategy'

module Warden
  module Ocra
    module Strategies
      class OcraVerify < BaseStrategy
        def valid?
          has_challenge?
        end

        def authenticate!
          user = find_user
          response = Rocra.generate(
            Warden::Ocra::config.suite,
            user.send(Warden::Ocra::config.user_shared_secret_method),
            '',
            user.send(Warden::Ocra::config.user_challenge_method).to_i.to_s(16),
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
