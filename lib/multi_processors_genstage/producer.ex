defmodule Producer do
  use GenStage
  require Logger

  def start_link(num_events) do
    state = %{events: List.duplicate("foo", num_events)}
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:producer, state}
  end

  @impl true
  def handle_demand(demand, state) do
    {events, remaining} = Enum.split(state.events, demand)

    if length(remaining) == 0 do
      Logger.info("Production ended")
    end

    events = for event <- events, do: {event, System.monotonic_time()}

    state = %{state | events: remaining}
    {:noreply, events, state}
  end
end
