[![Build Status](https://travis-ci.org/sorentwo/knuckles.svg?branch=master)](https://travis-ci.org/sorentwo/knuckles)
[![Coverage Status](https://coveralls.io/repos/github/sorentwo/knuckles/badge.svg?branch=master)](https://coveralls.io/github/sorentwo/knuckles?branch=master)
[![Code Climate](https://codeclimate.com/github/sorentwo/knuckles/badges/gpa.svg)](https://codeclimate.com/github/sorentwo/knuckles)

# Knuckles (Because Sonic was Taken)

Knuckles is a performance focused data serialization pipeline. More simply, it
tries to serialize models into large JSON payloads as quickly as possible.

### What's it all about?

* Emphasis on caching as a composable operation
* Reduced object instantiation
* Complete instrumentation of every discrete operation
* Entirely agnostic, can be dropped into any project and integrated over time
* Minimal runtime dependencies
* Explicit serializer view API with as little overhead and no DSL

### Is It Better?

Knuckles is absolutely faster and has a lower memory overhead than uncached
or cached usage of `ActiveModelSerializers`, and significantly faster than
cached use of `ActiveModelSerializers` with the [perforated][perforated] gem.

Here are performance and memory comparisons for an endpoint that has been cached
with Perforated and with Knuckles. All measurments were done with production
settings over the local network.

|                | average | longest | shortest | allocated | retained |
| -------------- | ------- | ------- | -------- | --------- | -------- |
| perforated/ams | 230ms   | 560ms   | 190ms    | 148,735   | 18,203   |
| knuckles/ams	 | 30ms    | 60ms    | 20ms     | 19,603    | 136      |

These are measurements for a sizable payload with hundreds of associated
records.

[perforated]: https://github.com/sorentwo/perforated

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

## Defining Views for Rendering

While you can use Knuckles with other serializers, you can also use the provided
view layer. Knuckles views are simple templates that let you build up data and
relations. They look like this:

```ruby
module ScoutView
  extend Knuckles::View

  def self.root
    :scouts
  end

  def self.data(object, options)
    {id: object.id, email: object.email, name: object.name}
  end

  def self.relations(object, options)
    {things: has_many(object.things, ThingView)}
  end
end
```

See `Knuckles::View` for more usage details.

## Contributing

1. Fork it ( https://github.com/sorentwo/knuckles/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
