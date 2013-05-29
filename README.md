# Warden::Ocra

Warden strategy for [OCRA: OATH Challenge-Response Algorithm (rfc 6287)](http://tools.ietf.org/html/rfc6287)

## Installation

Add this line to your application's Gemfile:

    gem 'warden-ocra'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install warden-ocra

## Usage

The authentication requires two steps:

1. post a user identifier (e.g. email address)
   this generates the challenge for that user, no authentication is performed
2. post the user and the answer to the challenge
   this actually authenticates the user

### Sinatra sample setup

See [the spec sample sinatra app](https://github.com/koffeinfrei/warden-ocra/blob/master/spec/lib/warden_ocra_spec.rb) for more details.

```ruby
use Rack::Session::Cookie
use Warden::Manager do |config|
  config.default_strategies :ocra_verify, :ocra_challenge
  config.failure_app = YourApp
end
```

```ruby
# step 1
post '/generate_challenge' do
  env["warden"].authenticate!
  # generates env["warden"].user.challenge
end

# step 2
post '/login' do
  env["warden"].authenticate!
  # performs the actual authentication
end
```

A ``User`` class is assumed to have the following methods.
The user class and its method names can be configured if your model has different methods.

* ``User.find_by_email!(email)``
* ``User.has_challenge?(email)``
* ``User.generate_challenge!(email)``
* ``User#shared_secret``
* ``User#challenge``

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
