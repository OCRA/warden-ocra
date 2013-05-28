module Warden
  module Ocra
    module Strategies
      class BaseStrategy < Warden::Strategies::Base
        def user_param
          params[Warden::Ocra::config.param_user_identifier]
        end
      end
    end
  end
end
