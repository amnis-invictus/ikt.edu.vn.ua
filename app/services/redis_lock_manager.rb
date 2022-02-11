class RedisLockManager
  CONNECTION = Redis.new

  SCRIPTS = %i[lock unlock].index_with { CONNECTION.script :load, File.read(Rails.root.join "lib/redis/#{_1}.lua") }.freeze

  class << self
    def acquired? key, token
      key = with_namespace key
      CONNECTION.get(key) == token
    end

    def acquire key, token
      key = with_namespace key
      CONNECTION.evalsha(SCRIPTS[:lock], keys: [key, token]) == 1
    end

    def release key, token
      key = with_namespace key
      CONNECTION.evalsha(SCRIPTS[:unlock], keys: [key, token]) == 1
    end

    def release_all token
      keys = CONNECTION.smembers token
      CONNECTION.multi do |transaction|
        keys.each { |key| transaction.evalsha SCRIPTS[:unlock], keys: [key, token] }
      end
    end

    def with_lock key, token
      do_release = acquire key, token
      acquired?(key, token).tap { yield if _1 }
    ensure
      release key, token if do_release
    end

    def all
      keys = CONNECTION.keys 'locks:*'
      values = CONNECTION.multi { |transaction| keys.each { transaction.get _1 } }
      keys.map { _1[6..] }.zip(values).to_h
    end

    private

    def with_namespace(key) = "locks:#{key}"
  end
end
