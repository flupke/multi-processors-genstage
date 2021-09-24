defmodule Analysis do
  use GenStage

  def start_link(id) do
    GenStage.start_link(__MODULE__, [], name: process_name(id))
  end

  @impl true
  def init(state) do
    {:producer_consumer, state, subscribe_to: [{Producer, max_demand: 1}]}
  end

  @impl true
  def handle_events(events, _from, state) do
    events =
      for {event_name, start_time} <- events do
        num_highlights = Core.analyse()
        {event_name, start_time, num_highlights}
      end

    {:noreply, events, state}
  end

  def process_name(id), do: :"Analysis_#{id}"
end
