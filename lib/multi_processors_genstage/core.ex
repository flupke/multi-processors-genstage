defmodule Core do
  def analyse() do
    processing_duration = Enum.random(10..20)
    Process.sleep(processing_duration)
    :rand.uniform(10)
  end

  def encode(num_highlights) do
    Process.sleep(num_highlights * 10)
  end
end
