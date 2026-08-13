defmodule Mix.Tasks.Blueprint.Gzip do
  @moduledoc """
  Emits `.gz` siblings for compressible assets in `priv/static`.

  Apps depending on `:blueprint` serve its assets via `Plug.Static`
  with `from: {:blueprint, "priv/static"}`. `mix phx.digest` only
  touches the app's own `priv/static`, so without this task the
  dep-served CSS ships uncompressed over Tor on every fresh page
  load. Run automatically from the `compile` alias so any downstream
  `mix deps.compile blueprint` refreshes the `.gz` siblings.

  Fonts (`.woff2`) are already Brotli-compressed inside the WOFF2
  wrapper — gzipping them makes the payload larger, so they are
  skipped.
  """
  use Mix.Task

  @shortdoc "Emit .gz siblings for compressible dep-served static assets"
  @compressible ~w(.css .js .svg .wasm .txt .json .html)
  @priv_static "priv/static"

  @impl Mix.Task
  def run(_args) do
    if File.dir?(@priv_static) do
      compress_all()
    else
      :ok
    end
  end

  defp compress_all do
    sources =
      @priv_static
      |> Path.join("**/*")
      |> Path.wildcard()
      |> Enum.filter(&(File.regular?(&1) and Path.extname(&1) in @compressible))

    Enum.each(sources, fn source ->
      target = source <> ".gz"
      compressed = source |> File.read!() |> :zlib.gzip()
      File.write!(target, compressed)
    end)

    Mix.shell().info("blueprint.gzip: emitted #{length(sources)} .gz sibling(s)")
  end
end
