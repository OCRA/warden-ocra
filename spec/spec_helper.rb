require 'warden-ocra'

require 'rack/test'
require 'sinatra'
require 'warden'
include Warden::Test::Helpers

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.after(:each){ Warden.test_reset! }
end

class User
  class << self
    attr_accessor :users

    def create(attrs={})
      self.users ||= []
      self.users << new(attrs)
    end
  end

  attr_accessor :id, :email, :challenge, :shared_secret

  def initialize(attrs={})
    attrs.each { |key, value| send("#{key}=", value) }
  end

  def self.find_by_email!(email)
    users.find { |u| u.email == email }
  end

  def self.generate_challenge!(email)
    u = User.find_by_email!(email)
    u.challenge = rand.to_s[-8,8]
    u.challenge = '41538504' # -> reponse 239172
    u
  end

  def self.has_challenge?(email)
    !User.find_by_email!(email).challenge.nil?
  end
end

class TestApp < Sinatra::Base
  configure do
    User.create :email => 'bla@blub.com', :shared_secret => 'c0b93c552e593c4a'
  end

  get '/' do
    "hello"
  end

  post '/generate_challenge' do
    env["warden"].authenticate!
    # @user = env['warden'].user
  end

  post '/login' do
    env["warden"].authenticate!
    # redirect '/'
  end
end

def app
  Rack::Builder.new do
    use Rack::Session::Cookie
    # Warden::Manager.serialize_into_session { |user| user.id }
    # Warden::Manager.serialize_from_session { |id| User.get(id) }

    # Warden::Strategies.add :ocra_verify, Warden::Ocra::Strategies::OcraVerify
    # Warden::Strategies.add :ocra_challenge, Warden::Ocra::Strategies::OcraChallenge
    use Warden::Manager do |config|
      config.default_strategies :ocra_verify, :ocra_challenge
      config.failure_app = TestApp
    end
    # use Warden::Manager do |manager|
    #   manager.default_strategies :ocra, :ocra_challenge
    #   manager.failure_app = TestApp
    # end

    run TestApp
  end
end
