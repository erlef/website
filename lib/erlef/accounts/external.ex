defmodule Erlef.Accounts.External do
  @moduledoc """
  Erlef.Accounts.External provides a schema and helper functions for converting external accounts to an Erlef app 
  member or member attributes. 

  While this module is called External to leave it open, the only supported external account is Wildapricot. 

  The module is intended to serve as boundary between the accounts context and wildapricot data structures.

  See `Erlef.Accounts.Member` for more details about members.
  """
  use Erlef.Schema
  alias Erlef.Accounts.Member

  @primary_key false
  embedded_schema do
    field(:id, :string, redact: true)
    field(:source, Ecto.Enum, values: [:wildapricot])
  end

  def changeset(external, attrs) do
    external
    |> cast(attrs, [:id, :source])
    |> validate_required([:id, :source])
  end

  # The following is used to map wildapricot fields to normalized atoms for use
  # within the app. Likewise,it used to construct lists that are in turn used to map this struct back to
  # the wildapricot format. Note that the structure below is flat, where as the wildapricot data 
  # structure is not, in particular the "FieldValues" section of a contact is a list of maps.
  #
  # Per the above we annotate fields that are part of the "FieldValues" list.
  @str_key_map %{
    "Status" => {:status, :field_value},
    "Archived" => {:is_archived, :field_value},
    "DisplayName" => :name,
    "Donor" => {:is_donor, :field_value},
    "Email" => {:email, :field_value},
    "Group participation" => {:roles, :field_value},
    "Id" => {:external, :embed},
    "FirstName" => :first_name,
    "LastName" => :last_name,
    "Member since" => {:member_since, :field_value},
    "MembershipEnabled" => :membership_enabled,
    "MembershipLevel" => :membership_level,
    "Suspended member" => {:suspended_member, :field_value},
    "TermsOfUseAccepted" => :terms_of_use_accepted,
    "erlef_app_id" => {:id, :field_value},
    "erlef_email_address" => {:erlef_email_address, :field_value},
    "has_email_alias" => {:has_email_alias, :field_value},
    "has_email_box" => {:has_email_box, :field_value}
  }

  # We build these lists so that we don't have to compute them at runtime. 
  # They are used for mapping Member fields back to wildapricot fields and forms. 
  @field_value_key_map Enum.filter(@str_key_map, fn {_k, v} -> is_tuple(v) end)

  @membership_level_str_map %{
    "Basic Membership" => :basic,
    "Annual Supporting Membership" => :annual,
    "Lifetime Supporting Membership" => :lifetime,
    "Board" => :board,
    "Fellow" => :fellow,
    "Managing and Contributing" => :contributor
  }

  @spec to_member_params(map(), map()) :: map()
  @doc """
  Casts a wildapricot contact to member parameters which
  can be utilized to create a member.
  """

  def to_member_params(contact, %{from: :wildapricot}) do
    contact
    |> map_main_values()
    |> map_embeds(contact)
    |> normalize_level()
    |> map_field_values(contact)
    |> normalize_member_since()
    |> group_participation_to_roles()
    |> set_properties()
  end

  @spec to_member(map(), map()) :: map()
  @doc """
  Casts a wildapricot contact to an erlef app member.
  """

  def to_member(contact, %{from: :wildapricot} = args) do
    params = to_member_params(contact, args)

    struct(Member, params)
  end

  @allowed %{id: true, erlef_email_address: true, has_email_box: true, has_email_alias: true}

  def to_external(%Member{external: %{id: id, source: :wildapricot}}, params) do
    %{"Id" => id, "FieldValues" => to_field_values(@allowed, params)}
  end

  defp normalize_member_since(%{member_since: since} = val) do
    {:ok, dt, _} = DateTime.from_iso8601(since)
    Map.put(val, :member_since, DateTime.to_date(dt))
  end

  defp normalize_member_since(val), do: val

  defp normalize_level(%{membership_level: %{"Name" => level}} = val) do
    Map.put(val, :membership_level, @membership_level_str_map[level])
  end

  defp normalize_level(val), do: val

  defp group_participation_to_roles(%{roles: []} = val), do: val

  defp group_participation_to_roles(%{roles: roles} = val) do
    transformed =
      Enum.reduce(roles, [], fn x, acc ->
        case x do
          %{"Label" => "Website Admin"} -> [:app_admin | acc]
          _ -> acc
        end
      end)

    Map.put(val, :roles, transformed)
  end

  defp group_participation_to_roles(val), do: val

  defp to_field_values(allowed, params) do
    Enum.reduce(@field_value_key_map, [], fn {wa_key, {k, _}}, acc ->
      case {Map.has_key?(allowed, k), Map.has_key?(params, k)} do
        {true, true} -> [%{"FieldName" => wa_key, "Value" => format_field_value(params[k])} | acc]
        _ -> acc
      end
    end)
  end

  defp format_field_value(true), do: "true"
  defp format_field_value(false), do: "false"
  defp format_field_value(val), do: val

  defp set_properties(member_map) do
    props = %{
      has_email_box: true_string_or_false(member_map, :has_mail_box),
      has_email_alias: true_string_or_false(member_map, :has_mail_alias),
      is_app_admin: maybe_app_admin(member_map),
      has_email_address: maybe_has_email_address(member_map)
    }

    Map.merge(member_map, props)
  end

  defp maybe_has_email_address(%{erlef_email_address: nil}), do: false
  defp maybe_has_email_address(%{erlef_email_address: ""}), do: false
  defp maybe_has_email_address(%{erlef_email_address: _}), do: true
  defp maybe_has_email_address(_), do: false

  defp maybe_app_admin(%{roles: []}), do: false
  defp maybe_app_admin(%{roles: roles}), do: :app_admin in roles
  defp maybe_app_admin(val), do: val

  defp true_string_or_false(map, key) do
    case Map.get(map, key) do
      "true" ->
        true

      _ ->
        false
    end
  end

  defp map_main_values(contact) do
    contact
    |> Map.delete("FieldValues")
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      case @str_key_map[k] do
        nil ->
          acc

        key when is_atom(key) ->
          Map.put(acc, key, v)

        _ ->
          acc
      end
    end)
  end

  def map_embeds(member_map, %{"Id" => id}) when is_integer(id) do
    Map.put(member_map, :external, %{id: Integer.to_string(id), source: :wildapricot})
  end

  def map_embeds(member_map, %{"Id" => id}) do
    Map.put(member_map, :external, %{id: id, source: :wildapricot})
  end

  def map_embeds(member_map, _), do: member_map

  defp map_field_values(member_map, %{"FieldValues" => field_values}) do
    Enum.reduce(field_values, member_map, fn f, acc ->
      case @str_key_map[f["FieldName"]] do
        {key, :field_value} ->
          Map.put(acc, key, f["Value"])

        _ ->
          acc
      end
    end)
  end

  defp map_field_values(member_map, _), do: member_map
end
