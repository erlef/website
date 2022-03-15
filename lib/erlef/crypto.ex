defmodule Erlef.Crypto do
  @moduledoc """
  Erlef.Crypto

  Provides wrappers around common cryptographic operations and dependencies
  """

  @doc """
  Compares two strings using `Plug.Crypto.secure_compare/2` to mitigate timing attacks.
  """
  @spec compare(String.t(), String.t()) :: boolean()
  def compare(str1, str2), do: Plug.Crypto.secure_compare(str1, str2)

  @doc """
  Computes Message Authentication Code (MAC) via `:erlang.mac/4`. 
  The computed MAC is base 16 encoded and lower cased. 
  """
  @spec hmac_encode(binary(), binary()) :: String.t()
  def hmac_encode(key, data) do
    :hmac
    |> :crypto.mac(:sha3_256, key, data)
    |> Base.encode16(case: :lower)
  end
end
