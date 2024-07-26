import Config

config :logger, level: :warning

config :peridiod_persistence,
  kv_backend: PeridiodPersistence.KVBackend.UBootEnv
