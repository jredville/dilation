require 'rubygems'
require 'dilation'

class WakeHandler
  def call
    puts 'awake'
  end
end

def stop_handler
  puts 'stop'
end

c = Dilation::Core.new

trap 'INT' do
  c.stop
  abort
end

c.listen_for :start do puts 'start' end
c.listen_for :stop, method(:stop_handler)
c.listen_for :sleep, lambda { puts 'sleep' }
c.listen_for :wake, WakeHandler.new
c.listen_for :tick, lambda { puts 'tick' }

puts 'sleeping'

c.sleep 5

puts 'starting'
counter = 0

c.listen_for :tick, lambda { counter += 1 }

c.start
while counter < 5
end

c.stop

puts 'ok'
