defmodule MultiProcessorsGenstage.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    pool_opts = [
      name: {:local, :ffmpeg_pool},
      worker_module: Ffmpeg,
      size: 6,
      max_overflow: 0
    ]

    children =
      [
        Telemetry,
        :poolboy.child_spec(:ffmpeg_pool, pool_opts),
        {Producer, 1_000_000}
      ] ++
        for(
          i <- 1..24,
          do: Supervisor.child_spec({Processing, i}, id: Processing.process_name(i))
        )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MultiProcessorsGenstage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
