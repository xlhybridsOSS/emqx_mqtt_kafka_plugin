-module(xl_kafka_bridge_plugin).

-include_lib("emqttd/include/emqttd.hrl").

-export([load/1, unload/0]).

load(Env) ->
  'Elixir.MqttKafka':load(Env).

unload() ->
  'Elixir.MqttKafka':unload().
