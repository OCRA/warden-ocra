module Warden
  module Ocra
    module Strategies
      class BaseStrategy < Warden::Strategies::Base
        def user_param
          params[Warden::Ocra::config.param_user_identifier]
        end

        def generate_challenge
          Warden::Ocra::config.user_class.send(
            Warden::Ocra::config.generate_challenge_method,
            user_param
          )
        end

        def has_challenge?
          user_param && Warden::Ocra::config.user_class.send(
            Warden::Ocra::config.has_challenge_method,
            user_param
          )
        end

        def find_user
          Warden::Ocra::config.user_class.send(
            Warden::Ocra::config.user_finder_method,
            user_param
          )
        end
      end
    end
  end
end
