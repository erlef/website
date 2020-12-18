defmodule Erlef.Accounts.Member do
  @moduledoc """
  Erlef.Accounts.Member provides functions and a struct for fetching and updating erlef members.
  It serves as boundary between the erlef app and the wildapricot client, api, and its data structures.

  Data retreived from the erlef wildapricot database is flattened and presented in such a way
  that the rest of the application is not tighly coupled to wildapricot's platform. 

  Likewise, data passed to functions in this module used for updating the erlef wildapricot database does not
  require the caller to know the underlying data structure nor the wildapricot api.

  ## Virtual fields

   The following fields are virtual and can not be updated. Updating corresponding fields will change the 
   result of the virtual field. 

    - `is_app_admin?`
    - `is_paying?` 
    - `has_email_address?`

  For more details on Wildapricot see `Erlef.Wildapricot`. 
  """

  # Member levels we consider to be "paid" members.
  @paid_member_levels [
    "Annual Supporting Membership",
    "Lifetime Supporting Membership",
    "Board",
    "Fellow",
    "Managing and Contributing"
  ]

  # The following is used to map wildapricot fields to normalized atoms for use
  # within the app. Likewise,it used to construct lists that are in turn used to map this struct back to
  # the wildapricot format. Note that the structure below is flat, where as the wildapricot data 
  # structure is not, in particular the "FieldValues" section of a contact is a list of maps.
  #
  # Per the above we annotate fields that are part of the "FieldValues" list.
  @str_key_map %{
    "Archived" => {:is_archived?, :field_value},
    "DisplayName" => :name,
    "Donor" => {:is_donor?, :field_value},
    "Email" => {:email, :field_value},
    "FirstName" => :first_name,
    "Group participation" => {:group_participation, :field_value},
    "Id" => :wild_apricot_id,
    "Last login date" => :last_login_date,
    "LastName" => :last_name,
    "Member" => {:is_member?, :field_value},
    "Member since" => {:member_since, :field_value},
    "MembershipEnabled" => :membership_enabled,
    "MembershipLevel" => :membership_level,
    "Organization" => :organization,
    "Street address" => :street_address,
    "Suspended member" => {:suspended_member, :field_value},
    "TermsOfUseAccepted" => :terms_of_use_accepted,
    "Url" => :url,
    "erlef_app_id" => {:id, :field_value},
    "erlef_email_address" => {:erlef_email_address, :field_value},
    "has_email_alias" => {:has_email_alias?, :field_value},
    "has_email_box" => {:has_email_box?, :field_value}
  }

  # We build these lists so that we don't have to compute them at runtime. 
  # They are used for mapping Member fields back to wildapricot fields and forms. 
  # @root_key_map Enum.filter(@str_key_map, fn {_k, v} -> is_atom(v) end)
  @field_value_key_map Enum.filter(@str_key_map, fn {_k, v} -> is_tuple(v) end)

  @fields [
    :name,
    :email,
    :erlef_email_address,
    :first_name,
    :group_participation,
    :has_email_alias?,
    :has_email_box?,
    :has_email_address?,
    :id,
    :is_app_admin?,
    :is_archived?,
    :is_donor?,
    :is_member?,
    :is_paying?,
    :last_login_date,
    :last_name,
    :member_since,
    :membership_enabled,
    :membership_level,
    :organization,
    :street_address,
    :suspended_member,
    :terms_of_use_accepted,
    :url,
    :wild_apricot_id
  ]

  @field_str_map Enum.reduce(@fields, %{}, fn k, acc ->
                   Map.put(acc, Atom.to_string(k), k)
                 end)

  @derive Jason.Encoder
  defstruct @fields

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          name: String.t(),
          email: String.t(),
          erlef_email_address: String.t() | nil,
          first_name: String.t(),
          group_participation: [map()] | nil,
          has_email_alias?: boolean(),
          has_email_box?: boolean(),
          has_email_address?: boolean(),
          is_app_admin?: boolean(),
          is_archived?: boolean(),
          is_donor?: boolean(),
          is_member?: boolean(),
          is_paying?: boolean(),
          last_login_date: String.t() | nil,
          last_name: String.t(),
          member_since: String.t(),
          membership_enabled: boolean(),
          membership_level: map(),
          organization: String.t() | nil,
          street_address: String.t() | nil,
          suspended_member: String.t() | nil,
          terms_of_use_accepted: boolean(),
          url: String.t(),
          wild_apricot_id: integer()
        }

  def build(data) do
    normal =
      Enum.reduce(data, %{}, fn {k, v}, acc ->
        case @field_str_map[k] do
          nil ->
            acc

          key ->
            Map.put(acc, key, v)
        end
      end)

    struct(__MODULE__, normal)
  end

  @spec get(Ecto.UUID.t() | integer() | String.t()) :: {:ok, term()} | term()
  @doc """
  Retrieves a member. 
  """
  def get(<<_::binary-size(36)>> = uuid) do
    case Erlef.WildApricot.get_contact_by_field_value("erlef_app_id", uuid) do
      {:ok, contact} ->
        {:ok, from_contact(contact)}

      error ->
        error
    end
  end

  def get(uid) do
    case Erlef.WildApricot.get_contact(uid) do
      {:ok, contact} ->
        {:ok, from_contact(contact)}

      {:error, %{status: 404}} ->
        {:error, :not_found}

      error ->
        error
    end
  end

  @spec from_contact(map()) :: t()
  @doc """
  Casts a wildapricot contact to an erlef app member.
  """
  def from_contact(contact) do
    member =
      contact
      |> map_main_values()
      |> map_field_values(contact["FieldValues"])
      |> set_properties()

    struct(__MODULE__, member)
  end

  @spec update(t(), map()) :: {:ok, t()} | {:error, term()}
  def update(%__MODULE__{wild_apricot_id: id}, params) do
    field_updates = to_field_values(params)
    wa_params = %{"Id" => id, "FieldValues" => field_updates}

    case Erlef.WildApricot.update_contact(id, wa_params) do
      {:ok, contact} ->
        {:ok, from_contact(contact)}

      err ->
        err
    end
  end

  ### Private

  defp is_paying?(%{membership_level: level}) do
    level["Name"] in @paid_member_levels
  end

  defp is_paying?(_), do: false

  defp to_field_values(params) do
    Enum.reduce(@field_value_key_map, [], fn {wa_key, {k, _}}, acc ->
      case Map.has_key?(params, k) do
        true -> [%{"FieldName" => wa_key, "Value" => format_field_value(params[k])} | acc]
        false -> acc
      end
    end)
  end

  defp format_field_value(true), do: "true"
  defp format_field_value(false), do: "false"
  defp format_field_value(val), do: val

  defp set_properties(member_map) do
    props = %{
      has_mail_box?: true_string_or_false(member_map, :has_mail_box),
      has_mail_alias?: true_string_or_false(member_map, :has_mail_alias),
      is_paying?: is_paying?(member_map),
      is_app_admin?: maybe_app_admin(member_map),
      has_email_address?: maybe_has_email_address(member_map)
    }

    Map.merge(member_map, props)
  end

  defp maybe_has_email_address(%{erlef_email_address: nil}), do: false
  defp maybe_has_email_address(%{erlef_email_address: ""}), do: false
  defp maybe_has_email_address(%{erlef_email_address: _}), do: true
  defp maybe_has_email_address(_), do: false

  defp maybe_app_admin(%{group_participation: val}), do: in_website_admin?(val)
  defp maybe_app_admin(_), do: false

  defp true_string_or_false(map, key) do
    case Map.get(map, key) do
      "true" ->
        true

      _ ->
        false
    end
  end

  defp in_website_admin?([]), do: false

  defp in_website_admin?(groups) when is_list(groups) do
    case Enum.find(groups, fn x -> x["Label"] == "Website Admin" end) do
      %{"Label" => "Website Admin"} -> true
      _ -> false
    end
  end

  defp in_website_admin?(_), do: false

  defp map_main_values(contact) do
    contact
    |> Map.delete("FieldValues")
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      case @str_key_map[k] do
        key when is_atom(key) ->
          Map.put(acc, key, v)

        _ ->
          acc
      end
    end)
  end

  defp map_field_values(member_map, field_values) do
    Enum.reduce(field_values, member_map, fn f, acc ->
      case @str_key_map[f["FieldName"]] do
        {key, :field_value} ->
          Map.put(acc, key, f["Value"])

        _ ->
          acc
      end
    end)
  end
end
