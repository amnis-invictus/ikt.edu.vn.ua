if redis.call("get", KEYS[1]) == KEYS[2] and redis.call("del", KEYS[1]) == 1 then
  return redis.call("srem", KEYS[2], KEYS[1])
else
  return 0
end
