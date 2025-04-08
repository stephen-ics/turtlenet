defmodule TurtlenetTest do
  use ExUnit.Case
  doctest Turtlenet

  test "greets the world" do
    assert Turtlenet.hello() == :world
  end
end
