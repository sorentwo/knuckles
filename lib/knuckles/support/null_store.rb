module Knuckles
  module Support
    class NullStore
      def fetch_multi(*keys)
        keys.each_with_object({}) do |name, memo|
          memo[name] = yield name
        end
      end
    end
  end
end
