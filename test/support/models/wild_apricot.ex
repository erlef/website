defmodule Erlef.Test.WildApricot do
  @moduledoc false

  # n.b., strings such as "account_id", "admin" and "basic_member" are used in place of integer ids
  # in this model. 

  # The following are base profiles for different personas. Said base profiles are merged
  # with default profile data. See test/support/models/wild_apricot/data.ex for more detail.

  # n.b., all profiles except the basic member profile have erlef_app_id(s) (UUID(s)). This
  # is for testing the mechanism in the app that is responsible for populating this field.
  # Otherwise, testing other features would be a bit of pain since we don't persist data in 
  # ets between runtime(s)
  #
  @base_admin_profile %{
    "DisplayName" => "Admin",
    "Email" => "admin@foo.bar",
    "FirstName" => "Admin",
    "Id" => "admin",
    "LastName" => "Admin",
    "MembershipLevel" => %{
      "Id" => "1234567",
      "Name" => "Admin Admin",
      "Url" => "https://api.wildapricot.org/v2.2/accounts/010101/MembershipLevels/1234567"
    },
    "IsAccountAdministrator" => true,
    "FieldValues" => [
      %{
        "FieldName" => "Group participation",
        "SystemCode" => "Groups",
        "Value" => [
          %{"Id" => "654321", "Label" => "Website Admin"}
        ]
      },
      %{
        "FieldName" => "erlef_app_id",
        "SystemCode" => "custom-12523894",
        "Value" => "55d3a339-a768-4410-839a-bd7e29616450"
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
      "Id" => "1234567",
      "Name" => "Basic Membership",
      "Url" => "https://api.wildapricot.org/v2.2/accounts/010101/MembershipLevels/1234567"
    }
  }

  @base_annual_profile %{
    "DisplayName" => "Annual Supporting Member",
    "Email" => "annual_supporting_member@foo.bar",
    "FirstName" => "Annual",
    "Id" => "annual_member",
    "LastName" => "Supporting Member",
    "MembershipLevel" => %{
      "Id" => "1234567",
      "Name" => "Annual Supporting Membership",
      "Url" => "https://api.wildapricot.org/v2.2/accounts/010101/MembershipLevels/1234567"
    },
    "FieldValues" => [
      %{
        "FieldName" => "erlef_app_id",
        "SystemCode" => "custom-12523894",
        "Value" => "874e3414-ebf2-4ed5-b0fb-eb704b18cd05"
      }
    ]
  }

  @base_lifetime_profile %{
    "DisplayName" => "Lifetime Supporting Member",
    "Email" => "life_supporting_member@foo.bar",
    "FirstName" => "Lifetime",
    "Id" => "lifetime_member",
    "LastName" => "Supporting Member",
    "MembershipLevel" => %{
      "Id" => "1234567",
      "Name" => "Lifetime Supporting Membership",
      "Url" => "https://api.wildapricot.org/v2.2/accounts/010101/MembershipLevels/1234567"
    },
    "FieldValues" => [
      %{
        "FieldName" => "erlef_app_id",
        "SystemCode" => "custom-12523894",
        "Value" => "494df2a5-1c4d-4544-a9b9-a12fb2e49b8d"
      }
    ]
  }

  @base_lifetime_profile %{
    "DisplayName" => "Lifetime Member",
    "Email" => "lifetime_member@foo.bar",
    "FirstName" => "Lifetime",
    "Id" => "lifetime_member",
    "LastName" => "Member",
    "MembershipLevel" => %{
      "Id" => "1234567",
      "Name" => "Fellow",
      "Url" => "https://api.wildapricot.org/v2.2/accounts/010101/MembershipLevels/1234567"
    },
    "FieldValues" => [
      %{
        "FieldName" => "erlef_app_id",
        "SystemCode" => "custom-12523894",
        "Value" => "06339432-fa6d-4f82-890d-5c72493ae476"
      }
    ]
  }

  @base_fellow_profile %{
    "DisplayName" => "Fellow Member",
    "Email" => "fellow@foo.bar",
    "FirstName" => "Fellow",
    "Id" => "fellow_member",
    "LastName" => "Member",
    "MembershipLevel" => %{
      "Id" => "1234567",
      "Name" => "Fellow",
      "Url" => "https://api.wildapricot.org/v2.2/accounts/010101/MembershipLevels/1234567"
    },
    "FieldValues" => [
      %{
        "FieldName" => "erlef_app_id",
        "SystemCode" => "custom-12523894",
        "Value" => "5d5e213f-476f-496d-841d-d93af03b6ed7"
      }
    ]
  }

  # Static data for each type of member used in the return from the ../me endpoint
  @stub_data_map %{
    "admin" => Erlef.Test.WildApricot.Data.contact_data(@base_admin_profile),
    "basic_member" => Erlef.Test.WildApricot.Data.contact_data(@base_basic_profile),
    "annual_member" => Erlef.Test.WildApricot.Data.contact_data(@base_annual_profile),
    "lifetime_member" => Erlef.Test.WildApricot.Data.contact_data(@base_lifetime_profile),
    "fellow_member" => Erlef.Test.WildApricot.Data.contact_data(@base_fellow_profile)
  }

  use Plug.Router
  plug(:match)
  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Jason
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
    _tid = :ets.new(__MODULE__, [:named_table, :public, {:write_concurrency, true}])
    Enum.each(@stub_data_map, fn {k, v} -> true = :ets.insert(__MODULE__, {k, v}) end)
    Plug.Cowboy.http(__MODULE__, [], ref: ref, port: 9999)
  end

  def stop(ref \\ __MODULE__) do
    Plug.Cowboy.shutdown(ref)
  end

  post "/auth/token" do
    case gen_auth_token(conn) do
      "invalid" ->
        data = %{
          "error" => "invalid_grant",
          "error_description" => "Authorization code was not found.",
          "error_uri" => nil
        }

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(data))

      code ->
        data = %{
          "Permissions" => [
            %{
              "AccountId" => "account_id",
              "AvailableScopes" => ["contacts_me", "account_view"],
              "SecurityProfileId" => "42"
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

  post "/v2.2" do
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
          "SecurityProfileId" => "42"
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

  get "/v2.2/accounts/:aid/contacts/me" do
    token = get_auth_token(conn)

    me_data = %{
      "Id" => @stub_data_map[token]["Id"],
      "DisplayName" => @stub_data_map[token]["DisplayName"]
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(me_data))
  end

  get "/v2.2/accounts/:aid/contacts" do
    case conn.params do
      %{"$filter" => <<"erlef_app_id eq ", uuid::binary-size(36)>>} ->
        contacts = lookup_by_uuid(uuid)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{"Contacts" => contacts}))

      _ ->
        send_resp(conn, 500, "")
    end
  end

  get "/v2.2/accounts/:aid/contacts/:id" do
    case :ets.lookup(__MODULE__, id) do
      [{_id, contact}] ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(contact))

      [] ->
        send_resp(conn, 404, "")
    end
  end

  put "/v2.2/accounts/:aid/contacts/:id" do
    case :ets.lookup(__MODULE__, id) do
      [{_id, contact}] ->
        contact = update_contact(id, contact, conn.params)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(contact))

      [] ->
        send_resp(conn, 404, "")
    end
  end

  defp update_contact(id, contact, params) do
    new = Map.merge(contact, params)

    new =
      case Map.has_key?(params, "FieldValues") do
        true ->
          specified_fields = Enum.map(params["FieldValues"], & &1["FieldName"])
          without = Enum.reject(contact["FieldValues"], &(&1["FieldName"] in specified_fields))
          Map.put(new, "FieldValues", params["FieldValues"] ++ without)

        false ->
          new
      end

    true = :ets.insert(__MODULE__, {id, new})
    new
  end

  defp lookup_by_uuid(uuid) do
    res =
      Enum.find(@stub_data_map, fn {k, _v} ->
        [{_, contact}] = :ets.lookup(__MODULE__, k)
        fv = contact["FieldValues"]

        case find_uuid_in_fv(fv, uuid) do
          %{"Value" => ^uuid} ->
            true

          _ ->
            false
        end
      end)

    case res do
      {_k, contact} -> [contact]
      _ -> []
    end
  end

  defp find_uuid_in_fv(fv, uuid) do
    Enum.find(fv, fn f -> f["FieldName"] == "erlef_app_id" and f["Value"] == uuid end)
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
