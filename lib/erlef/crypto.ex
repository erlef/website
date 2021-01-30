defmodule Erlef.Crypto do
  @moduledoc false

  def compare(str1, str2), do: Plug.Crypto.secure_compare(str1, str2)

  def hmac_encode(key, data) do
    :hmac
    |> :crypto.mac(:sha3_256, key, data)
    |> Base.encode16(case: :lower)
  end
end
