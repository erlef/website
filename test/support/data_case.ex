defmodule Erlef.DataCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require database connections.
  """

  defmacro __using__(opts \\ []) do
    quote do
      use ExUnit.Case, unquote(opts)

      import Erlef.Factory
      import Erlef.DataCase

      alias Erlef.Repo

      setup _tags do
        :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
        :ok = Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
      end
    end
  end

  @doc """
  A helper that transfor changeset errors into a map of messages.
  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts
        |> Keyword.get(String.to_existing_atom(key), key)
        |> to_string()
      end)
    end)
  end
end
