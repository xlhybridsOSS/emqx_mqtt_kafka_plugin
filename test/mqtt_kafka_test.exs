defmodule MqttKafkaTest do
  use ExUnit.Case
  doctest MqttKafka

  test "greets the world" do
    assert MqttKafka.hello() == :world
  end
end
