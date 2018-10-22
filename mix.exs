defmodule MqttKafka.MixProject do
  use Mix.Project

  def project do
    [
      app: :mqtt_kafka,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :lager, :compiler, :elixir],
      erl_opts: [parse_transform: "lager_transform"],
      mod: {MqttKafka.App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:distillery, "~> 2.0"},
      {:dialyzex, "~> 1.2.0", only: :dev},
      {:lager, "~> 3.6", override: true},
      {:emqx, git: "https://github.com/xlhybridsoss/emqx.git", branch: "lager-tag", only: :dev},
      {:erlkaf, git: "https://github.com/silviucpp/erlkaf.git", branch: "master"}
    ]
  end
end
