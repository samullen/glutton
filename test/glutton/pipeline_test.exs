defmodule Glutton.PipelineTest do
  use ExUnit.Case, async: true

  alias Glutton.Pipeline

  test "test message" do
    start_supervised({Pipeline, []})

    ref = Broadway.test_message(Pipeline, ["url"])

    assert_receive {:ack, ^ref, [%{data: ["url"]}], []}
  end

end
