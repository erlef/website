defmodule Erlef.Crypto do
  @moduledoc false

  def compare(str1, str2), do: Plug.Crypto.secure_compare(str1, str2)
end
