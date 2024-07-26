defmodule PeridiodPersistence.KVTest do
  use ExUnit.Case
  # doctest PeridiodPersistence.KV

  alias PeridiodPersistence.KV

  @moduletag capture_log: true

  @kv %{
    "a.peridio_uuid" => "d9492bdb-94de-5288-425e-2de6928ef99c",
    "b.peridio_uuid" => "4e08ad59-fa3c-5498-4a58-179b43cc1a25",
    "peridio_active" => "b"
  }

  setup context do
    options =
      context[:kv_options] ||
        [kv_backend: {PeridiodPersistence.KVBackend.InMemory, contents: @kv}]

    {:ok, kv_pid} = KV.start_link(options, [])
    KV.get_all(kv_pid)
    Map.put(context, :kv_pid, kv_pid)
  end

  test "can get single value from kv", context do
    assert KV.get(context.kv_pid, "peridio_active") == "b"
  end

  test "can get all values from kv", context do
    assert KV.get_all(context.kv_pid) == @kv
  end

  test "can get all active values from kv", context do
    active = Map.get(@kv, "peridio_active")

    active_values =
      @kv
      |> Enum.filter(&String.starts_with?(elem(&1, 0), active))
      |> Enum.map(&{String.trim_leading(elem(&1, 0), active <> "."), elem(&1, 1)})
      |> Enum.into(%{})

    assert KV.get_all_active(context.kv_pid) == active_values
  end

  test "can get single active value from kv", context do
    active_value = Map.get(@kv, "b.peridio_uuid")
    assert KV.get_active(context.kv_pid, "peridio_uuid") == active_value
  end

  test "put/2", context do
    assert :ok = KV.put(context.kv_pid, "test_key", "test_value")
    assert KV.get(context.kv_pid, "test_key") == "test_value"
  end

  test "put/1", context do
    assert :ok =
             KV.put_map(context.kv_pid, %{
               "test_key1" => "test_value1",
               "test_key2" => "test_value2"
             })

    assert KV.get(context.kv_pid, "test_key1") == "test_value1"
    assert KV.get(context.kv_pid, "test_key2") == "test_value2"
  end

  test "put_active/2", context do
    assert :ok = KV.put_active(context.kv_pid, "active_test_key", "active_test_value")
    assert KV.get_active(context.kv_pid, "active_test_key") == "active_test_value"
  end

  test "put_active/1", context do
    assert :ok =
             KV.put_active_map(context.kv_pid, %{
               "active_test_key1" => "active_test_value1",
               "active_test_key2" => "active_test_value2"
             })

    assert KV.get_active(context.kv_pid, "active_test_key1") == "active_test_value1"
    assert KV.get_active(context.kv_pid, "active_test_key2") == "active_test_value2"
  end

  @tag kv_options: [
         kv_backend: {PeridiodPersistence.KVBackend.InMemory, contents: %{"key" => "value"}}
       ]
  test "old modules configuration", context do
    assert KV.get(context.kv_pid, "key") == "value"

    assert :ok = KV.put(context.kv_pid, "test_key", "test_value")
    assert KV.get(context.kv_pid, "test_key") == "test_value"
  end

  @tag kv_options: [
         kv_backend: {PeridiodPersistence.KVBackend.InMemory, contents: %{"key" => "value"}}
       ]
  test "old configuration", context do
    assert KV.get(context.kv_pid, "key") == "value"

    assert :ok = KV.put(context.kv_pid, "test_key", "test_value")
    assert KV.get(context.kv_pid, "test_key") == "test_value"
  end

  @tag kv_options: [kv_backend: PeridiodPersistence.KVBackend.InMemory]
  test "empty configuration", context do
    assert KV.get_all(context.kv_pid) == %{}
  end

  @tag kv_options: [kv_backend: PeridiodPersistence.KVBackend.BadBad]
  test "bad configuration reverts to empty", context do
    assert KV.get_all(context.kv_pid) == %{}
  end
end
