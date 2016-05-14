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

## Understanding and Using Pipelines

Knuckles renders and serializes data through a series of stages composed into a
pipeline. Stages can easily be added or removed to control how data is
transformed. Here is a breakdown of the default stages and what their role is
within the pipeline.

#### Fetcher

The fetcher is responsible for bulk retrieval of data from the cache. Fetching
is done using a single `read_multi` operation, which is multiplexed in caches
like Redis or MemCached.

```ruby
pipeline = Knuckles::Pipeline.new

pipeline.call(posts)
```

#### Hydrator

Models that couldn't be retrieved from the cache will then be hydrated, a
process where the stripped down model that was given for fetching is replaced
with a full model with preloaded associations. The behavior of the hydrator
stage is entirely controlled by passing a Proc as the `hydrate` option. If the
`hydrate` proc is omitted hydration will be skipped. Skipping hydration is
useful if you want a simplified pipeline where full models and their
associations are preloaded before starting serialization.

See `Knuckles::Active::Hydrator` for an alternative `ActiveRecord` specific
hydrator. If you are using Knuckles within a Rais app, this is probably the
hydration stage you want to use.

```ruby
# Using the standard hydrator
pipeline.call(posts, hydrator: -> (model) { model.fetch })

# Using active hydrator with a relation that has a `prepared` scope
pipeline.call(posts, relation: posts.prepared)
```

#### Renderer

After un-cached models have been hydrated they can be rendered. Rendering is
synonymous with converting a model to a hash, like calling `as_json` on an
`ActiveRecord` model. Knuckles provides a minimal (but fast) view module that
can be used with the rendering step. Alternatively, if you're migrating from
`ActiveModelSerializers` you can pass in an AMS class instead.

```ruby
# Using Knuckles::View
pipeline.call(models, view: PostView)

# Using ActiveModelSerializer
pipeline.call(models, view: PostSerializer)
```

#### Writer

After un-cached models have been serialized they are ready to be cached for
future retrieval. Each fully serialized model is written to the cache in a
single `write_multi` operation if available (using Readthis, for example). Only
previously un-cached data will be written to the cache, making the writer a
no-op when all of the data was cached initially.

#### Enhancer

The enhancer modifies rendered data using proc passed through options. The
enhancer stage is critical to customizing the final output. For example, if
staff should have confidential data that regular users can't see you can enhance
the final values. Another use of enhancers is personalizing an otherwise generic
response.

```ruby
# Removing "confidential" data from the rendered data
pipeline.call(posts,
  scope: current_user,
  enhancer: lambda do |result, options|
    scope = options[:scope]

    unless scope.staff?
      result.delete_if { |key, _| key == "confidential" }
    end

    result
  end
)
```

#### Combiner

The combiner stage merges all of the individually rendered results into a single
hash. The output of this stage is a single object, ready to be serialized.

#### Dumper

The dumping process combines de-duplication and actual serialization. For every
top level key that is an array all of the children will have uniqueness
enforced. For example, if you had rendered a collection of posts that shared the
same author, you will only have a single author object serialized. Be aware that
the uniqueness check relies on the presence of an `id` key rather than full
object comparisons.

Dumping is the final stage of the pipeline. At this point you have a single
serialized payload in the format of your choice (JSON by default), ready to send
back as a response.

## Customizing Pipelines

Pipelines stages can be removed, swapped out or otherwise tuned. An array of
stages can be passed when building a new pipeline. Here is an example of
creating a customized pipeline without any caching, hydration, or enhancing:

```ruby
Knuckles::Pipeline.new(stages: [
  Knuckles::Stages::Renderer,
  Knuckles::Stages::Combiner,
  Knuckles::Stages::Dumper
])
```

Or, perhaps you want to use the active hydrator instead:

```ruby
Knuckles::Pipeline.new(stages: [
  Knuckles::Stages::Fetcher,
  Knuckles::Active::Hydrator,
  Knuckles::Stages::Renderer,
  Knuckles::Stages::Writer,
  Knuckles::Stages::Enhancer,
  Knuckles::Stages::Combiner,
  Knuckles::Stages::Dumper
])
```

Note that once the pipeline is initialized the stages are frozen to prevent
modification.

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
