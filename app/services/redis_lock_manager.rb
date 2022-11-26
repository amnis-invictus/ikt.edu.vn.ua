class RedisLockManager
  POOL = ConnectionPool.new(size: ENV.fetch('RAILS_MAX_THREADS', 5)) { Redis.new }

  POOL.with do |redis|
    self::SCRIPTS = %i[lock unlock].index_with do |script|
      redis.script :load, Rails.root.join("lib/redis/#{script}.lua").read
    end.freeze
  end

  class << self
    def acquired? key, token
      key = with_namespace key
      POOL.with { _1.get key } == token
    end

    def acquire key, token
      key = with_namespace key
      POOL.with { _1.evalsha SCRIPTS[:lock], keys: [key, token] } == 1
    end

    def release key, token
      key = with_namespace key
      POOL.with { _1.evalsha SCRIPTS[:unlock], keys: [key, token] } == 1
    end

    def release_all token
      POOL.with do |redis|
        keys = redis.smembers token
        redis.multi do |transaction|
          keys.each { |key| transaction.evalsha SCRIPTS[:unlock], keys: [key, token] }
        end
      end
    end

    def with_lock key, token
      do_release = acquire key, token
      acquired?(key, token).tap { yield if _1 }
    ensure
      release key, token if do_release
    end

    def all
      POOL.with do |redis|
        keys = redis.keys 'locks:*'
        values = redis.multi { |transaction| keys.each { transaction.get _1 } }
        keys.pluck(6..).zip(values).to_h
      end
    end

    private

    def with_namespace(key) = "locks:#{key}"
  end
end
