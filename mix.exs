defmodule Blueprint.MixProject do
  use Mix.Project

  def project do
    [
      app: :blueprint,
      version: "0.1.0",
      elixir: "~> 1.19",
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run blueprint.gzip after every compile so dep-served static
  # assets ship with a `.gz` sibling for Plug.Static to serve.
  defp aliases do
    [compile: ["compile", "blueprint.gzip"]]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_html, "~> 4.0"},
      {:eqrcode, "~> 0.2"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
