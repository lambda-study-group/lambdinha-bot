defmodule LambdaStudyGroupBotTest do
  use ExUnit.Case
  doctest LambdaStudyGroupBot

  test "greets the world" do
    assert LambdaStudyGroupBot.hello() == :world
  end
end
