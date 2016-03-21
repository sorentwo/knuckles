[![Build Status](https://travis-ci.org/sorentwo/knuckles.svg?branch=master)](https://travis-ci.org/sorentwo/knuckles)
[![Coverage Status](https://coveralls.io/repos/github/sorentwo/knuckles/badge.svg?branch=master)](https://coveralls.io/github/sorentwo/knuckles?branch=master)
[![Code Climate](https://codeclimate.com/github/sorentwo/knuckles/badges/gpa.svg)](https://codeclimate.com/github/sorentwo/knuckles)

# Knuckles (Because Sonic was Taken)

What's it all about?

* Emphasis on caching as a composable operation
* Reduced object instantiation
* Complete instrumentation of every discrete operation
* Entirely agnostic, can be dropped into any project and integrated over time
* Minimal runtime dependencies
* Explicit serializer view API with as little overhead and no DSL

## Installation

Add this line to your application's Gemfile:

```ruby
gem "knuckles"
```

## Configuration

There isn't a hard dependency on `Oj` or `Readthis`, but you'll find they are
drastically more performant.

```ruby
require "activesupport"
require "oj"
require "readthis"

Knuckles.configure do |config|
  config.cache = Readthis::Cache.new(
    marshal: Oj,
    compress: true,
    driver: :hiredis
  )

  config.keygen = Readthis::Expanders
  config.serializer = Oj
end
```

With the top level module configured it is simple to jump right into rendering,
but we'll look at configuring the pipeline first.

## Defining Views

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
