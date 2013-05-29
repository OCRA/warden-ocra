require 'warden'
require 'rocra'

require 'warden-ocra/version'
require 'warden-ocra/strategies/ocra_verify'
require 'warden-ocra/strategies/ocra_challenge'
require 'warden-ocra/configuration'

module Warden
  module Ocra
    Warden::Manager.serialize_into_session { |user| user.id }
    Warden::Manager.serialize_from_session { |id| config.user_class.get(id) }

    Warden::Strategies.add :ocra_verify, Strategies::OcraVerify
    Warden::Strategies.add :ocra_challenge, Strategies::OcraChallenge
  end
end
