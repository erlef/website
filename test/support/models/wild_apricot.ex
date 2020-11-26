defmodule Erlef.Test.WildApricot do
  @moduledoc false

  # n.b., strings such as "account_id", "admin" and "basic_member" are used in place of integer ids
  # in this model. 

  # The following are base profiles for different personas. Said base profiles are merged
  # with default profile data. See test/support/models/wild_apricot/data.ex for more detail.
  @base_admin_profile %{
    "DisplayName" => "Admin",
    "Email" => "admin@foo.bar",
    "FirstName" => "Admin",
    "Id" => "admin",
    "LastName" => "Admin",
    "MembershipLevel" => %{
      "Id" => 12345,
      "Name" => "Admin Admin",
      "Url" => "https://api.wildapricot.org/v2.1/accounts/010101/MembershipLevels/1234567"
    },
    "IsAccountAdministrator" => true,
    "FieldValues" => [
      %{
        "FieldName" => "Group participation",
        "SystemCode" => "Groups",
        "Value" => [
          %{"Id" => 654_321, "Label" => "Website Admin"}
        ]
      }
    ]
  }

  @base_basic_profile %{
    "DisplayName" => "Basic Member",
    "Email" => "basic_member@foo.bar",
    "FirstName" => "Basic",
    "LastName" => "Member",
    "Id" => "basic_member",
    "MembershipLevel" => %{
      "Id" => 1234,
      "Name" => "Basic Membership",
      "Url" => "https://api.wildapricot.org/v2.1/accounts/010101/MembershipLevels/1234567"
    }
  }

  @base_annual_profile %{
    "DisplayName" => "Annual Supporting Member",
    "Email" => "annual_supporting_member@foo.bar",
    "FirstName" => "Annual",
    "Id" => "annual_member",
    "LastName" => "Supporting Member",
    "MembershipLevel" => %{
      "Id" => 12_345_67,
      "Name" => "Annual Supporting Membership",
      "Url" => "https://api.wildapricot.org/v2.1/accounts/010101/MembershipLevels/1234567"
    }
  }

  @base_lifetime_profile %{
    "DisplayName" => "Lifetime Supporting Member",
    "Email" => "life_supporting_member@foo.bar",
    "FirstName" => "Lifetime",
    "Id" => "lifetime_member",
    "LastName" => "Supporting Member",
    "MembershipLevel" => %{
      "Id" => 12_345_67,
      "Name" => "Lifetime Supporting Membership",
      "Url" => "https://api.wildapricot.org/v2.1/accounts/010101/MembershipLevels/1234567"
    }
  }

  @base_lifetime_profile %{
    "DisplayName" => "Fellow Member",
    "Email" => "fellow@foo.bar",
    "FirstName" => "Fellow",
    "Id" => "fellow_member",
    "LastName" => "Member",
    "MembershipLevel" => %{
      "Id" => 12_345_67,
      "Name" => "Fellow",
      "Url" => "https://api.wildapricot.org/v2.1/accounts/010101/MembershipLevels/1234567"
    }
  }

  @base_fellow_profile %{
    "DisplayName" => "Fellow Member",
    "Email" => "fellow@foo.bar",
    "FirstName" => "Fellow",
    "Id" => "fellow_member",
    "LastName" => "Member",
    "MembershipLevel" => %{
      "Id" => 12_345_67,
      "Name" => "Fellow",
      "Url" => "https://api.wildapricot.org/v2.1/accounts/010101/MembershipLevels/1234567"
    }
  }

  # Static data for each type of member used in the return from the ../me endpoint
  @stub_data_map %{
    "admin" => Erlef.Test.WildApricot.Data.contact_data(@base_admin_profile),
    "basic_member" => Erlef.Test.WildApricot.Data.contact_data(@base_basic_profile),
    "annual_member" => Erlef.Test.WildApricot.Data.contact_data(@base_annual_profile),
    "lifetime_member" => Erlef.Test.WildApricot.Data.contact_data(@base_lifetime_profile),
    "fellow" => Erlef.Test.WildApricot.Data.contact_data(@base_fellow_profile)
  }

  use Plug.Router
  plug(:match)
  plug Plug.Parsers, parsers: [:urlencoded]
  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def init(options), do: options

  def start_link(_opts) do
    start()
  end

  def start(ref \\ __MODULE__) do
    Plug.Cowboy.http(__MODULE__, [], ref: ref, port: 9999)
  end

  def stop(ref \\ __MODULE__) do
    Plug.Cowboy.shutdown(ref)
  end

  post "/auth/token" do
    code = gen_auth_token(conn)

    data = %{
      "Permissions" => [
        %{
          "AccountId" => "account_id",
          "AvailableScopes" => ["contacts_me", "account_view"],
          "SecurityProfileId" => 42_42_42
        }
      ],
      "access_token" => code,
      "expires_in" => 1_800,
      "refresh_token" => "rt_#{code}",
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
          "AccountId" => "account_id",
          "AvailableScopes" => [
            "contacts_view",
            "finances_view",
            "emails_view",
            "events_view",
            "event_registrations_view",
            "account_view",
            "membership_levels_view"
          ],
          "SecurityProfileId" => 42_42_42
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

  get "/v2.1/accounts/:aid/contacts/me" do
    token = get_auth_token(conn)

    me_data = %{
      "Id" => @stub_data_map[token]["Id"],
      "DisplayName" => @stub_data_map[token]["DisplayName"]
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(me_data))
  end

  get "/v2.1/accounts/:aid/contacts/:id" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(@stub_data_map[id]))
  end

  def gen_auth_token(conn) do
    case conn.params["grant_type"] do
      "authorization_code" ->
        conn.params["code"]

      "refresh_token" ->
        <<"rt_", rt_code::binary>> = conn.params["refresh_token"]
        rt_code

      "client_credentials" ->
        "client_token"
    end
  end

  def get_auth_token(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> parse_bearer()
  end

  def parse_bearer([<<"Bearer ", token::binary>>]), do: token
  def parse_bearer(_), do: {:error, :invalid_token}
end
