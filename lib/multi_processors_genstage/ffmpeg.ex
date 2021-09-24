defmodule Ffmpeg do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:encode, num_highlights}, _from, state) do
    Core.encode(num_highlights)
    {:reply, :ok, state}
  end
end
