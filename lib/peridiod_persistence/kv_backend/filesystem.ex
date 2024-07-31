defmodule PeridiodPersistence.KVBackend.Filesystem do
  @moduledoc """
  Filesystem KV store

  This KV store keeps everything in memory. Use it by specifying it
  as a backend in the application configuration. Specifying an initial
  set of contents is optional.

  ```elixir
  config :peridiod, :kv_backend, {PeridiodPersistence.KV.Filesystem, path: "/path/to/storage_folder", file: "filename"}
  ```
  """
  @behaviour PeridiodPersistence.KVBackend.Behaviour

  @default_filename "peridio-state"

  @impl PeridiodPersistence.KVBackend.Behaviour
  def load(options) do
    file_path = Path.join(path(options), file(options))

    with true <- File.exists?(file_path),
         {:ok, encoded_state} <- File.read(file_path) do
      decode(encoded_state)
    else
      false -> {:ok, %{}}
      error -> error
    end
  end

  @impl PeridiodPersistence.KVBackend.Behaviour
  def save(new_state, options) do
    path = path(options)
    file_path = Path.join(path, file(options))

    with :ok <- File.mkdir_p(path),
         {:ok, encoded_state} <- encode(new_state) do
      File.write(file_path, encoded_state)
    else
      error -> error
    end
  end

  defp encode(state) when is_map(state) do
    Jason.encode(state)
  end

  defp decode(encoded_state) when is_binary(encoded_state) do
    Jason.decode(encoded_state)
  end

  defp path(options) do
    Keyword.get(options, :path, default_path())
  end

  defp file(options) do
    Keyword.get(options, :file, @default_filename)
  end

  def default_path do
    case System.fetch_env("XDG_CONFIG_HOME") do
      {:ok, config_home} -> config_home
      :error -> Path.join(System.fetch_env!("HOME"), ".config")
    end
    |> Path.join("peridio")
  end
end
