class RedisLockManager
  CONNECTION = Redis.new

  UNLOCK_SCRIPT = <<-LUA.freeze
    if redis.call("get", KEYS[1]) == ARGV[1] then
      return redis.call("del", KEYS[1])
    else
      return 0
    end
  LUA

  UNLOCK_SCRIPT_SHA = CONNECTION.script(:load, UNLOCK_SCRIPT).freeze

  class << self
    def acquired? key, token
      CONNECTION.get(with_namespace key) == token
    end

    def acquire key, token
      key = with_namespace key
      acquired = CONNECTION.set key, token, nx: true
      CONNECTION.sadd token, key if acquired
      acquired
    end

    def release key, token
      key = with_namespace key
      released = CONNECTION.evalsha(UNLOCK_SCRIPT_SHA, keys: [key], argv: [token]) == 1
      CONNECTION.srem token, key if released
      released
    end

    def release_all token
      keys = CONNECTION.smembers token
      CONNECTION.multi do |transaction|
        keys.each { transaction.evalsha UNLOCK_SCRIPT_SHA, keys: [_1], argv: [token] }
        transaction.del token
      end
    end

    def with_lock key, token
      do_release = acquire key, token
      acquired?(key, token).tap { yield if _1 }
    ensure
      release key, token if do_release
    end

    private

    def with_namespace(key) = "locks:#{key}"
  end
end
