defmodule Glutton.URLQueue do
  use GenServer


  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def push(url) do
    GenServer.cast(__MODULE__, {:push, url})
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  @impl true
  def init(args), do: {:ok, args}

  @impl true
  def handle_call(:pop, _from, state) do
    [next_url | remaining_urls] = state
    {:reply, next_url, remaining_urls}
  end

  @impl true
  def handle_cast({:push, url}, state) do
    new_state = [url | state]
    {:noreply, new_state}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end
end
