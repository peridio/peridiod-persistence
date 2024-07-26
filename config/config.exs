import Config

config :peridiod_persistence,
  kv_backend:
    {PeridiodPersistence.KVBackend.InMemory,
     contents: %{
       "peridio_disk_devpath" => "/dev/mmcblk1"
     }}

import_config "#{Mix.env()}.exs"
