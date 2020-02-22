defmodule Erlef.Inputs do
  @moduledoc """
  Erlef.Inputs provides re-useable input validations
  """

  # TODO: Expand this to check the entire spec
  def is_email(addr) when byte_size(addr) <= 254 do
    case :binary.match(addr, "@") do
      :nomatch ->
        false

      _ ->
        case :binary.split(addr, "@") do
          [local, domain] when byte_size(local) <= 64 and byte_size(domain) <= 190 ->
            true

          _ ->
            false
        end
    end
  end

  def is_email(_), do: false
end
