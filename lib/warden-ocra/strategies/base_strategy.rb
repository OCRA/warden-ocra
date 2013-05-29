module Warden
  module Ocra
    module Strategies
      class BaseStrategy < Warden::Strategies::Base
        def user_param
          params[Warden::Ocra::config.param_user_identifier]
        end

        def user_class
          Kernel.const_get(Warden::Ocra::config.user_class)
        end

        def generate_challenge
          user_class.send(
            Warden::Ocra::config.generate_challenge_method,
            user_param
          )
        end

        def has_challenge?
          user_param && user_class.send(
            Warden::Ocra::config.has_challenge_method,
            user_param
          )
        end

        def find_user
          user_class.send(
            Warden::Ocra::config.user_finder_method,
            user_param
          )
        end
      end
    end
  end
end
