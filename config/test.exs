import Config

config :logger, level: :error

config :peridiod_persistence,
  kv_backend:
    {PeridiodPersistence.KVBackend.InMemory,
     contents: %{"peridio_disk_devpath" => "/dev/mmcblk1"}}
