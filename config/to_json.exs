defmodule ToJson do
  @moduledoc """
  Emit JSON structure representing all of the configuration state
  merged from non-runtime values
  """
  
  def doit do
    Mix.State.start_link([])
    Config.Reader.read_imports!("config/config.exs", env: :dev)
    |> case do
      {configs, _} -> configs
    end
    |> custom_encode()
    |> IO.puts()
  end

  def encoder([{_, _} | _] = value, state) do
    :json.encode_key_value_list(value, state)
  end
  def encoder(tup, state) when is_tuple(tup) do
    :json.encode_value(Tuple.to_list(tup), state)
  end
  def encoder(%Regex{} = re, state) do
    :json.encode_value(inspect(re), state)
  end
  def encoder(%DateTime{} = val, state) do
    :json.encode_value(DateTime.to_iso8601(val), state)
  end
  def encoder(other, state) do
    :json.encode_value(other, state)
  end
  def custom_encode(value),
      do: :json.encode(value, &encoder/2)
end
