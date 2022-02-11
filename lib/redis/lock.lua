if redis.call("setnx", KEYS[1], KEYS[2]) == 1 then
  return redis.call("sadd", KEYS[2], KEYS[1])
else
  return 0
end
