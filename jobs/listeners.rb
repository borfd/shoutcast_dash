listener_history = []
(1..60*60).each do |i|
  listener_history << {x:i, y: 0}
end

last_x = listener_history.last[:x]

tracker = ListenerTracker.new

start_time = Time.now

SCHEDULER.every '1s' do
  shoutcast = Shoutcast.new

  listener_history.shift
  last_x += 1
  listener_history << { x: last_x, y: shoutcast.listener_count }

  send_event('listener_graph', points: listener_history)

  send_event('listener_user_agents', items: shoutcast.user_agents)

  tracker.post_listeners shoutcast.ips
  send_event('unique_listeners', { current: tracker.unique_listeners, last: 0 })
end

SCHEDULER.every '1m' do
  shoutcast = Shoutcast.new
  send_event('nowplaying', text: shoutcast.now_playing)
  send_event('stream_hits', {current: shoutcast.stream_hits.to_i, last: 0})
end

SCHEDULER.every '5m' do
  shoutcast = Shoutcast.new
  send_event('peak', { value: shoutcast.peak_listeners.to_i })
end
