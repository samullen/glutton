defmodule Glutton.URLQueue do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def push(url) do
    GenServer.cast(__MODULE__, {:push, url})
  end

  def pop(count) do
    GenServer.call(__MODULE__, {:pop, count})
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  @impl GenServer
  def init(_args), do: {:ok, []}

  @impl GenServer
  def handle_cast({:push, url}, state) do
    {:noreply, [url | state]}
  end

  @impl GenServer
  def handle_call({:pop, count}, _from, state) do
    {urls, new_state} = Enum.split(state, count)
    {:reply, urls, new_state}
  end

  @impl GenServer
  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end
end
