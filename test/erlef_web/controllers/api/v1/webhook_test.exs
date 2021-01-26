defmodule ErlefWeb.API.V1.WebhookControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Integrations

  @audit_opts [audit: %{member_id: Ecto.UUID.generate()}]

  setup %{conn: conn} do
    {:ok, app} = Integrations.create_app(%{name: "Some app"}, @audit_opts)

    {:ok, app_key} =
      Integrations.create_app_key(app, %{name: "Some key", type: :webhook}, @audit_opts)

    conn = setup_conn(conn, app, app_key.app_secret)
    %{conn: conn, app: app, app_key: app_key, app_secret: app_key.app_secret}
  end

  describe "authorization" do
    test "returns 401 when not authorized", %{conn: conn} do
      bad_creds = Base.encode64(Ecto.UUID.generate() <> ":bar")

      conn =
        conn
        |> recycle()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Basic #{bad_creds}")
        |> post(Routes.api_v1_webhook_path(conn, :handle_post, "some_app"))

      assert json_response(conn, 401)
    end
  end

  describe "handle_post" do
    test "accepts a post request from a valid webhook client", %{
      conn: conn
    } do
      account_id = Application.get_env(:erlef, :wild_apricot) |> Keyword.get(:account_id)

      p = %{
        "MessageType" => "ContactModified",
        "AccountId" => account_id,
        "Parameters" => %{"Contact.Id" => 12_345}
      }

      conn = post(conn, Routes.api_v1_webhook_path(conn, :handle_post, "wildapricot"), p)
      assert json_response(conn, 200)
    end

    test "returns 401 when the webhook client is not known", %{
      conn: conn
    } do
      account_id = Application.get_env(:erlef, :wild_apricot) |> Keyword.get(:account_id)

      p = %{
        "MessageType" => "ContactModified",
        "AccountId" => account_id,
        "Parameters" => %{"Contact.Id" => 12_345}
      }

      conn = post(conn, Routes.api_v1_webhook_path(conn, :handle_post, "stranger_danger"), p)
      assert json_response(conn, 401)
    end

    test "returns 500 when the webhook client sends malformed params", %{
      conn: conn
    } do
      account_id = Application.get_env(:erlef, :wild_apricot) |> Keyword.get(:account_id)

      p = %{
        "MessageType" => "ContactModified",
        "AccountId" => account_id,
        "Parameters" => nil
      }

      conn = post(conn, Routes.api_v1_webhook_path(conn, :handle_post, "wildapricot"), p)
      assert json_response(conn, 500)
    end
  end

  defp setup_conn(conn, app, app_key_secret) do
    creds = Base.encode64(app.client_id <> ":" <> app_key_secret)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Basic #{creds}")
  end
end
