defmodule MqttKafka.Producer do
  use GenServer
  require Record

  Record.defrecord(:emqx_message, Record.extract(:message, from: "deps/emqx/include/emqx.hrl"))

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def forward_to_kafka(msg) do
    IO.puts "cast start"
    GenServer.cast(__MODULE__, {:publish, msg})
  end

  def init(:ok) do
    :ok = :erlkaf.start()

    producer_config = [
      {:bootstrap_servers, "broker1:9092"},
      {:delivery_report_only_error, false},
      {:delivery_report_callback, fn status, _message -> IO.puts("deliveryReport: #{status}") end}
    ]
    IO.puts "hello"

    :ok = :erlkaf.create_producer(:client_producer, producer_config)
    IO.puts "produce"
    :ok = :erlkaf.create_topic(:client_producer, "test", [{:request_required_acks, 1}])
    IO.puts "topic"
    {:ok, %{:producer_name => :client_producer, :topic => "test"}}
  end

  def terminate(_, %{:producer_name => producer_name}) do
    :erlkaf.stop_client(producer_name)
  end

  def handle_cast({:publish, msg}, state = %{:producer_name => producer_name, :topic => topic}) do
    IO.puts "cast"
    key = emqx_message(msg, :from)
    val = emqx_message(msg, :payload)
    :ok = produce(producer_name, topic, key, val)
    IO.puts "ok!"
    {:noreply, state}
  end

  defp produce(name, topic, key, val) do
    :erlkaf.produce(name, topic, key, val)
  end
end
