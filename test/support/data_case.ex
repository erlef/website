defmodule Erlef.DataCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require database connections.
  """

  defmacro __using__(opts \\ []) do
    quote do
      use ExUnit.Case, unquote(opts)

      import Erlef.Factory

      alias Erlef.Data.Repo

      setup _tags do
        :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
        :ok = Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
      end
    end
  end
end
