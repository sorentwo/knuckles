# Knuckles

What's it all about?

* Active Model Serializer familiar serializer API
* Emphasis on caching and composability
* Reduced object instantiation
* Optional complete instrumentation
* Entirely agnostic, can be dropped into any project
* Absolutely no runtime dependencies

## Installation

Add this line to your application's Gemfile:

```ruby
gem "knuckles"
```

## Configuration

```ruby
require "activesupport"
require "oj"
require "readthis"

Knuckles.configure do |config|
  config.json = Oj
  config.cache = Readthis::Cache.new
  config.notifications = ActiveSupport::Notifications
end
```

## Usage

The interface for defining serializers is largely based on Active Model
Serializers, but with a few key differences.

```ruby
class ScoutSerializer
  include Knuckles::Serializer

  root 'scout'

  attributes :id, :email, :display_name

  has_one  :thing, serializer: ThingSerializer
  has_many :other, serializer: OtherThingSerializer

  def display_name(object, options)
    "#{object.first_name} #{object.last_name}"
  end
end
```

## Contributing

1. Fork it ( https://github.com/sorentwo/knuckles/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
