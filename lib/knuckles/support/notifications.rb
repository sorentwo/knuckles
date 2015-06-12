module Knuckles
  module Support
    class Notifications
      def instrument(_name, payload)
        yield(payload)
      end
    end
  end
end
