class CacheStore

  def initialize(opts = {})
    @max_size_elements = Integer(opts[:max_size_elements] || 1024*25)
    @max_size_bytes    = Integer(opts[:max_size_bytes] || 1024*25)
    @max_duration      = Integer(opts[:max_duration] || (30 * 1000))
    @data              = {}
    @queue             = Queue.new
  end

  def clear
    @data.clear
    @queue.clear
  end

  def store(key, value)

    return if value.size > @max_size_bytes

    evict_by_max_elements
    evict_by_max_size(value.size)

    @data[key] = Datum.new(value, Time.now + @max_duration)
    @queue << key
  end

  def fetch(key)
    evict_by_expiration(key)

    datum = @data[key]
    datum ? datum.value : nil

    # this is the same (but better..) as:
    # if datum
    #   return datum.value
    # else
    #   nil
    # end
  end

  protected
  def evict_by_expiration(key)
    datum = @data[key]

    if datum && datum.expired?
      @data.delete(key)
      datum = nil
    end
  end

  def evict_by_max_size(new_element_size)
    while @data.values.size + new_element_size > @max_size_bytes
      key = @queue.pop
      @data.delete(key)
    end
  end

  def evict_by_max_elements
    while @queue.size > @max_size_elements
      key = @queue.pop
      @data.delete(key)
    end
  end

  class Datum
    attr_reader :value, :expires_at

    def initialize(value, expires_at)
      @value      = value
      @expires_at = expires_at
    end

    def expired?
      Time.now > expires_at
    end
  end
end
