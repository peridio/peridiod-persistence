defmodule PeridiodPersistence.KVFilesystemTest do
  use ExUnit.Case

  alias PeridiodPersistence.KV

  setup context do
    test_workspace_path = Path.join(["test", "workspace", "kv_filesystem"])
    File.mkdir_p!(test_workspace_path)

    options =
      context[:kv_options] ||
        [
          kv_backend:
            {PeridiodPersistence.KVBackend.Filesystem,
             path: test_workspace_path, file: to_string(context.test)}
        ]

    {:ok, kv_pid} = KV.start_link(options, [])
    KV.get_all(kv_pid)
    Map.put(context, :kv_pid, kv_pid)
  end

  test "load empty", context do
    assert KV.get_all(context.kv_pid) == %{}
  end

  test "get_and_update", context do
    assert :ok = KV.put(context.kv_pid, "foo", "bar")
    assert :ok = KV.put(context.kv_pid, "bar", "baz")
    # assert :ok = KV.get_and_update(context.kv_pid, "foo", fn _ -> :pop end)
    # assert %{"bar" => "baz"} = KV.get_all(context.kv_pid)
    assert :ok = KV.get_and_update(context.kv_pid, "bar", fn _ -> "baz" end)
    assert %{"foo" => "bar", "bar" => "baz"} = KV.get_all(context.kv_pid)
  end

  test "save", context do
    assert :ok = KV.put(context.kv_pid, "foo", "bar")
    assert %{"foo" => "bar"} = KV.get_all(context.kv_pid)
  end

  test "read back", context do
    assert :ok = KV.put(context.kv_pid, "foo", "bar")
    assert "bar" = KV.get(context.kv_pid, "foo")
  end
end
