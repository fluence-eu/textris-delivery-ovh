# Textris Delivery OVH

A [Textris](https://github.com/visualitypl/textris) delivery adapter for sending SMS messages via the [OVH API](https://api.ovh.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'textris-delivery-ovh', source: 'https://rubygems.pkg.github.com/fluence-eu'
```

Then execute:

```bash
bundle install
```

## Configuration

### OVH API Credentials

You need to obtain API credentials from OVH. Visit [OVH API Console](https://api.ovh.com/createToken/) to create your application keys.

#### Option 1: Environment Variables (Recommended)

Configure the gem using environment variables:

```bash
export OVH_SMS_SERVICE_NAME=sms-xx12345-1
export OVH_SMS_APPLICATION_KEY=your_application_key
export OVH_SMS_APPLICATION_SECRET=your_application_secret
export OVH_SMS_CONSUMER_KEY=your_consumer_key
```

#### Option 2: Ruby Initializer

Configure the gem via an initializer:

```ruby
# config/initializers/textris_ovh.rb
Textris::Delivery::Ovh.configure do |config|
  config.service_name = 'sms-xx12345-1'
  config.application_key = 'your_application_key'
  config.application_secret = 'your_application_secret'
  config.consumer_key = 'your_consumer_key'
end
```

### Textris Configuration

Configure Textris to use the OVH delivery adapter:

```ruby
# config/initializers/textris.rb
Textris.configure do |config|
  config.delivery_method = :ovh
end
```

## Usage

Once configured, use Textris as usual:

```ruby
class NotificationTexter < Textris::Base
  default from: 'YourCompany'

  def welcome(user)
    @user = user
    text to: @user.phone
  end
end

# Send SMS
NotificationTexter.welcome(user).deliver_now
```

## Requirements

- Ruby >= 3.1.0
- Textris gem
- Faraday ~> 1.0

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fluence-eu/textris-delivery-ovh.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).