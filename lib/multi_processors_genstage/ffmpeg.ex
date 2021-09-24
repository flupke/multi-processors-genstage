defmodule Ffmpeg do
  use GenStage

  def start_link(id) do
    GenStage.start_link(__MODULE__, [], name: process_name(id))
  end

  @impl true
  def init(state) do
    {:consumer, state,
     subscribe_to: for(i <- 1..24, do: {Analysis.process_name(i), max_demand: 1})}
  end

  @impl true
  def handle_events(events, _from, state) do
    for {_, start_time, num_highlights} <- events do
      Core.encode(num_highlights)
      duration = System.monotonic_time() - start_time
      :telemetry.execute([:event, :finished], %{duration: duration})
    end

    {:noreply, [], state}
  end

  def process_name(id), do: :"ffmpeg_#{id}"
end
