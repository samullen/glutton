defmodule GluttonTest do
  use ExUnit.Case
  doctest Glutton

  test "greets the world" do
    assert Glutton.hello() == :world
  end
end
