defmodule Erlef.Test.WildApricot do
  @moduledoc false

  use Plug.Router
  plug(:match)
  plug(:dispatch)

  def init(options), do: options

  def start(ref \\ __MODULE__) do
    Plug.Cowboy.http(__MODULE__, [], ref: ref, port: 9999)
  end

  def stop(ref \\ __MODULE__) do
    Plug.Cowboy.shutdown(ref)
  end

  post "/auth/token" do
    data = %{
      "Permissions" => [
        %{
          "AccountId" => 12_345,
          "AvailableScopes" => ["contacts_me", "account_view"],
          "SecurityProfileId" => 12_345
        }
      ],
      "access_token" => "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      "expires_in" => 1_800,
      "refresh_token" => "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      "token_type" => "Bearer"
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(data))
  end

  get "/auth/expiretoken" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{}))
  end

  get "/auth/deleterefreshtoken" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{}))
  end

  post "/v2.1" do
    data = %{
      "Permissions" => [
        %{
          "AccountId" => 12_345,
          "AvailableScopes" => [
            "contacts_view",
            "finances_view",
            "emails_view",
            "events_view",
            "event_registrations_view",
            "account_view",
            "membership_levels_view"
          ],
          "SecurityProfileId" => 123
        }
      ],
      "access_token" => "3dOo4f-KEg3D9t3nBDzSjbyjCTo-",
      "expires_in" => 1_800,
      "refresh_token" => "not_requested",
      "token_type" => "Bearer"
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(data))
  end

  get "/v2.1/accounts/12345/contacts/me" do
    data = %{
      "Id" => 12_345
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(data))
  end

  get "/v2.1/accounts/54321/contacts/me" do
    data = %{
      "Id" => 54_321
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(data))
  end

  get "/v2.1/accounts/:aid/contacts/:id" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(stub_contact_data(id)))
  end

  defp stub_contact_data("12345") do
    %{
      "FieldValues" => [
        %{
          "FieldName" => "Group participation",
          "SystemCode" => "Groups",
          "Value" => [
            %{"Id" => 1, "Label" => "Some group"},
            %{"Id" => 2, "Label" => "Website Admin"}
          ]
        }
      ],
      "Id" => 12_345
    }
  end

  defp stub_contact_data("54321") do
    %{
      "FieldValues" => [
        %{
          "FieldName" => "Group participation",
          "SystemCode" => "Groups",
          "Value" => [
            %{"Id" => 1, "Label" => "Some group"}
          ]
        }
      ],
      "Id" => 54_321
    }
  end
end
