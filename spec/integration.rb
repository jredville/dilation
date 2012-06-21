require 'dilation'

c = Dilation::Core.new

trap 'INT' do
  c.stop
  abort
end

counter = 0

c.listen_for :start, lambda { puts 'start' }
c.listen_for :stop, lambda { puts 'stop' }
c.listen_for :tick, lambda { puts 'tick' }
c.listen_for :tick, lambda { counter += 1 }

c.start

while counter < 5
end

c.stop

puts 'ok'