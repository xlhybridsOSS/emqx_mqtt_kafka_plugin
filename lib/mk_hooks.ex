defmodule MqttKafka do
  require Record

  Record.defrecord(:emqx_message, Record.extract(:message, from: "deps/emqx/include/emqx.hrl"))

  def load(env) do
    :ok = :emqx.hook(:'message.publish', &__MODULE__.on_message_publish/2, [env])
  end
  def unload() do
    :emqx.unhook(:'message.publish', &__MODULE__.on_message_publish/2)
  end

  def on_message_publish(msg, _env) do
    unless :emqx_message.get_flag(:sys, msg) do
      MqttKafka.Producer.forward_to_kafka(msg)
    end
    {:ok, msg}
  end
end
