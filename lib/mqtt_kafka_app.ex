defmodule MqttKafka.App do
  use Application

  def start(_type, _args) do
    {:ok, sup} = MqttKafka.Supervisor.start_link(name: MqttKafka.Supervisor)
    MqttKafka.load(:application.get_all_env())
    {:ok, sup}
  end

  def stop(_) do
    MqttKafka.unload()
  end
end

defmodule MqttKafka.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      MqttKafka.Producer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
