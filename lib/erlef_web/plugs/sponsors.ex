defmodule ErlefWeb.Plug.Sponsors do
  @moduledoc """
  Assigns the cached current sponsors to browser requests.
  """

  import Plug.Conn

  alias Erlef.Sponsors.Cache

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :sponsors, Enum.shuffle(Cache.all()))
  end
end
