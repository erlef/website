defmodule Erlef.Publications do
  @moduledoc """
  Context responsible for managing Academic Papers
  """

  alias Erlef.Publications.Query

  def all(), do: Query.published()
end
