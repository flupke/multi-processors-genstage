defmodule Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {TelemetryMetricsLogger, metrics: metrics(), reporter_options: [interval: 60]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp metrics do
    [
      summary("event.finished.duration", unit: {:native, :millisecond}),
      counter("event.finished.duration")
    ]
  end
end
