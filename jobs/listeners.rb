require 'nokogiri'
require 'open-uri'

class Shoutcast
    def noko
      listeners_uri = open("http://dirtybass.fm:8000/admin.cgi?sid=1&mode=viewxml&page=3",
        http_basic_authentication: ["admin", "dirtyisbetter"])
      Nokogiri::HTML(listeners_uri)
    end

    def listeners
      noko.css('listener').count
    end

    def user_agents
      noko.css('listener')
    end
end

listener_history = []
(1..10).each do |i|
  listener_history << {x:i, y: 0}
end
last_x = listener_history.last[:x]


SCHEDULER.every '3s' do
  listener_history.shift
  last_x += 1
  listener_history << { x: last_x, y: Shoutcast.new.listeners }

  send_event('listener_graph', points: listener_history)
end
