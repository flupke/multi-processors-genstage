defmodule MultiProcessorsGenstage.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        Telemetry,
        {Producer, 1_000_000}
      ] ++
        for(
          i <- 1..24,
          do: Supervisor.child_spec({Analysis, i}, id: Analysis.process_name(i))
        ) ++
        for(
          i <- 1..6,
          do: Supervisor.child_spec({Ffmpeg, i}, id: Ffmpeg.process_name(i))
        )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MultiProcessorsGenstage.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
