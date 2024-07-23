defmodule PhialTest do
  use ExUnit.Case
  doctest Phial

  test "greets the world" do
    assert Phial.hello() == :world
  end
end
