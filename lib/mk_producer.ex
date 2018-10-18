defmodule MqttKafka.Producer do
  use GenServer
  require Record

  Record.defrecord(:emqx_message, Record.extract(:message, from: "deps/emqx/include/emqx.hrl"))

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    :ok = :erlkaf.start()

    producer_config = [
      {:bootstrap_servers, "broker1:9092"},
      {:delivery_report_only_error, false},
      {:delivery_report_callback, fn status, _message -> IO.puts("deliveryReport: #{status}") end}
    ]

    :ok = :erlkaf.create_producer(:client_producer, producer_config)
    :ok = :erlkaf.create_topic(:client_producer, "test", [{:request_required_acks, 1}])
    {:ok, %{:producer_name => :client_producer, :topic => "test"}}
  end

  def handle_cast({:publish, msg}, state = %{:producer_name => producer_name, :topic => topic}) do
    key = emqx_message(msg, :from)
    val = emqx_message(msg, :payload)
    :ok = produce(producer_name, topic, key, val)
    {:noreply, state}
  end

  defp produce(name, topic, key, val) do
    :erlkaf.produce(name, topic, key, val)
  end
end
