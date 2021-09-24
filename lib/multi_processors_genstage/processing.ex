defmodule Processing do
  use GenStage

  def start_link(id) do
    GenStage.start_link(__MODULE__, [], name: process_name(id))
  end

  @impl true
  def init(state) do
    {:consumer, state, subscribe_to: [{Producer, max_demand: 1}]}
  end

  @impl true
  def handle_events(events, _from, state) do
    for {_, start_time} <- events do
      num_highlights = Core.analyse()
      :poolboy.transaction(:ffmpeg_pool, &GenServer.call(&1, {:encode, num_highlights}))
      duration = System.monotonic_time() - start_time
      :telemetry.execute([:event, :finished], %{duration: duration})
    end

    {:noreply, [], state}
  end

  def process_name(id), do: :"processing_#{id}"
end
