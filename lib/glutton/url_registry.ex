defmodule Glutton.URLRegistry do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def register(url) do
    GenServer.cast(__MODULE__, {:register, url})
  end

  def registered?(url) do
    GenServer.call(__MODULE__, {:registered?, url})
  end

  @impl GenServer
  def init(_args), do: {:ok, MapSet.new()}

  @impl GenServer
  def handle_cast({:register, url}, state) do
    {:noreply, MapSet.put(state, url)}
  end

  @impl GenServer
  def handle_call({:registered?, url}, _from, state) do
    {:reply, MapSet.member?(state, url), state}
  end
end
