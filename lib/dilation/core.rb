require_relative 'utils/events'
module Dilation
  class Core
    include Utils::Events
    event :tick, :start, :stop, :sleep, :wake
  end
end