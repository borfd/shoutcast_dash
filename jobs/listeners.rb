listener_history = []
(1..360).each do |i|
  listener_history << {x:i, y: 0}
end
last_x = listener_history.last[:x]


SCHEDULER.every '1s' do
  listener_history.shift
  last_x += 1
  listener_history << { x: last_x, y: Shoutcast.new.listener_count }

  send_event('listener_graph', points: listener_history)
end
