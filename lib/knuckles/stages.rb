# frozen_string_literal: true

module Knuckles
  module Stages
    autoload :Combiner, "knuckles/stages/combiner"
    autoload :Dumper, "knuckles/stages/dumper"
    autoload :Enhancer, "knuckles/stages/enhancer"
    autoload :Fetcher, "knuckles/stages/fetcher"
    autoload :Hydrator, "knuckles/stages/hydrator"
    autoload :Renderer, "knuckles/stages/renderer"
    autoload :Writer, "knuckles/stages/writer"
  end
end
