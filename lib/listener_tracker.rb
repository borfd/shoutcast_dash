require 'redis'

class ListenerTracker

  def initialize
    @redis = Redis.new
  end

  def post_listeners listeners
    @redis.sadd('ips', listeners)
  end

  def unique_listeners
    @redis.scard('ips')
  end
end
