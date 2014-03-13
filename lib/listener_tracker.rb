class ListenerTracker

  def initialize
    @listeners = Set.new
  end

  def post_listeners listeners
    @listeners.merge listeners
  end

  def unique_listeners
    @listeners.count
  end
end
