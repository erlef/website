defmodule Erlef.Members do
  @moduledoc """
  Erlef.Members context module
  """
  @spec get_display_name(integer()) :: String.t()
  def get_display_name(uid) do
    {:ok, %{"access_token" => token}} = Erlef.WildApricot.get_api_token()
    {:ok, %{"DisplayName" => name}} = Erlef.WildApricot.get_contact(token, uid)
    name
  end
end
