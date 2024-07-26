defmodule PeridiodPersistence.KVBackend.InMemory do
  @moduledoc """
  In-memory KV store

  This KV store keeps everything in memory. Use it by specifying it
  as a backend in the application configuration. Specifying an initial
  set of contents is optional.

  ```elixir
  config :peridiod, :kv_backend, {PeridiodPersistence.KV.InMemory, contents: %{"key" => "value"}}
  ```
  """
  @behaviour PeridiodPersistence.KVBackend.Behaviour

  @impl PeridiodPersistence.KVBackend.Behaviour
  def load(options) do
    case Keyword.fetch(options, :contents) do
      {:ok, contents} when is_map(contents) -> {:ok, contents}
      _ -> {:ok, %{}}
    end
  end

  @impl PeridiodPersistence.KVBackend.Behaviour
  def save(_new_state, _options), do: :ok
end
