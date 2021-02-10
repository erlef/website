defmodule ErlefWeb.Plug.Sponsors do
  @moduledoc """
  Sponsors are listed on every page thus we assign them to the conn regardless of the route (sans API).
  """

  import Plug.Conn

  alias Erlef.Groups

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :sponsors, Groups.list_sponsors())
  end
end
