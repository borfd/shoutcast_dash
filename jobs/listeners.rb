listener_history = []
(1..60*60).each do |i|
  listener_history << {x:i, y: 0}
end
last_x = listener_history.last[:x]


SCHEDULER.every '1s' do
  listener_history.shift
  last_x += 1
  shoutcast = Shoutcast.new
  listener_history << { x: last_x, y: shoutcast.listener_count }

  send_event('listener_graph', points: listener_history)

  send_event('listener_user_agents', items: shoutcast.user_agents)

  send_event('nowplaying', text: shoutcast.now_playing)
end
