defmodule Glutton.Pipeline do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Glutton.URLProducer, []},
        transformer: {__MODULE__, :transform, []},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 2,
          min_demand: 1,
          max_demand: 2
        ]
      ]
    )
  end

  def handle_message(:default, %Message{data: _data} = message, _context) do
    message
    |> IO.inspect
  end

  def transform(url, _opts) do
    %Broadway.Message{
      data: url,
      acknowledger: Broadway.NoopAcknowledger.init()
    }
  end

  def ack(_ref, _successes, _failures) do
    :ok
  end
end
