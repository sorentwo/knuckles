module Knuckles
  module Notifications
    def self.instrument(_name, payload)
      yield(payload)
    end
  end
end
