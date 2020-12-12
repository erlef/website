defmodule Erlef.Fellows do
  @moduledoc false

  @external_resource Erlef.data_path("fellows.exs")
  @fellows Erlef.get_data("fellows.exs")

  def all(), do: @fellows
end
