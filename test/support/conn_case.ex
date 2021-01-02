defmodule ErlefWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest

      import Erlef.Factory

      alias ErlefWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ErlefWeb.Endpoint

      def authenticated_conn(conn, username) do
        {:ok, session} = Erlef.Session.login(username)
        {:ok, session} = Erlef.Session.encode(%{"member_session" => session})
        {:ok, session} = Erlef.Session.decode(session)

        conn
        |> Plug.Test.init_test_session(session)
        |> Plug.Conn.fetch_session()
      end

      def admin_session(%{conn: conn}) do
        [conn: authenticated_conn(conn, "admin")]
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Erlef.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Erlef.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
