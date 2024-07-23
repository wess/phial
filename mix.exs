defmodule Phial.MixProject do
  use Mix.Project

  @source_url "https://github.com/wess/phial"
  @description "Handful of helpers for plug applications. No frameworks."
  @version File.read!("VERSION") |> String.trim()

  def project do
    [
      app: :phial,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "Plug.Cowboy",
        source_ref: "v#{@version}",
        source_url: @source_url,
        extras: []
      ],
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Wess Cope"],
      links: %{"Github" => @source_url}
    }
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "~> 0.18.0"},
      {:jason, "~> 1.4.3"},
      {:plug_cowboy, "~> 2.7.1"},
      {:ecto_sql, "~> 3.11.3"},
      {:httpoison, "~> 2.2.1"}
    ]
  end
end
