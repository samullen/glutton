defmodule Glutton.URLProducer do
  use GenStage

  alias Glutton.URLQueue

  @receive_interval 5_000

  def start_link(args) do
    GenStage.start_link(__MODULE__, args)
  end

  @impl GenStage
  def init(_args), do: {:producer, %{demand: 0}}

  @impl GenStage
  def handle_demand(incoming_demand, state) when incoming_demand > 0 do
    schedule_receive_messages(0)

    {:noreply, [], %{state | demand: state.demand + incoming_demand}}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end

  @impl GenStage
  def handle_info(:receive_messages, state) do
    case URLQueue.pop(state.demand) do
      urls when is_list(urls) and length(urls) > 0 ->
        {:noreply, urls, %{demand: state.demand - length(urls)}}

      [] ->
        schedule_receive_messages(@receive_interval)
        {:noreply, [], state}
    end

  end

  defp schedule_receive_messages(interval) do
    Process.send_after(self(), :receive_messages, interval)
  end
end
