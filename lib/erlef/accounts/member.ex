defmodule Erlef.Accounts.Member do
  @moduledoc false

  # Member levels we consider to be "paid" members.
  @paid_member_levels [
    "Annual Supporting Membership",
    "Lifetime Supporting Membership",
    "Board",
    "Fellow"
  ]

  # The following is used to map wildapricot fields to normalized atoms for use
  # within the app.
  @str_key_map %{
    "Url" => :url,
    "Bundle ID" => :bundle_id,
    "Suspended member" => :suspended_member,
    "Renewal due" => :renewal_due,
    "Street address" => :street_address,
    "TermsOfUseAccepted" => :terms_of_use_accepted,
    "City" => :city,
    "Email delivery disabled" => :email_delivery_disabled,
    "DisplayName" => :display_name,
    "Registered for specific event" => :registered_for_specific_event,
    "Id" => :id,
    "MembershipEnabled" => :membership_enabled,
    "Group participation" => :group_participation,
    "Zip" => :zip,
    "LastName" => :last_name,
    "Member emails and newsletters" => :member_emails_and_newsletters,
    "erlef_mail_address" => :erlef_mail_address,
    "FirstName" => :first_name,
    "Receiving emails disabled" => :receiving_emails_disabled,
    "IsAccountAdministrator" => :is_account_administrator,
    "Profile last updated by" => :profile_last_updated_by,
    "Member" => :member,
    "Privacy Policy" => :privacy_policy,
    "Email" => :email,
    "Level last changed" => :level_last_changed,
    "Country" => :country,
    "ProfileLastUpdated" => :profile_last_updated,
    "Administrator role" => :administrator_role,
    "MembershipLevel" => :membership_level,
    "User ID" => :user_id,
    "Status" => :status,
    "has_mail_box" => :has_mail_box,
    "Organization" => :organization,
    "Notes" => :notes,
    "Donor" => :donor,
    "Subscription source" => :subscription_source,
    "Last login date" => :last_login_date,
    "Member role" => :member_role,
    "Balance" => :balance,
    "Archived" => :archived,
    "Membership status" => :membership_status,
    "Event registrant" => :event_registrant,
    "Member since" => :member_since,
    "Event announcements" => :event_announcements,
    "Membership level ID" => :membership_level_id,
    "Avatar" => :avatar,
    "has_mail_alias" => :has_mail_alias,
    "Renewal date last changed" => :renewal_date_last_changed,
    "Total donated" => :total_donated,
    "Phone" => :phone,
    "Creation date" => :creation_date,
    "Access to profile by others" => :access_to_profile_by_others
  }

  defstruct [
    :access_to_profile_by_others,
    :administrator_role,
    :archived,
    :avatar,
    :balance,
    :bundle_id,
    :city,
    :country,
    :creation_date,
    :display_name,
    :donor,
    :email,
    :email_delivery_disabled,
    :erlef_mail_address,
    :event_announcements,
    :event_registrant,
    :first_name,
    :group_participation,
    :has_mail_box,
    :has_mail_alias,
    :id,
    :is_paying?,
    :last_login_date,
    :last_name,
    :level_last_changed,
    :member,
    :member_emails_and_newsletters,
    :member_role,
    :member_since,
    :membership_enabled,
    :membership_level,
    :membership_level_id,
    :membership_status,
    :notes,
    :organization,
    :phone,
    :privacy_policy,
    :profile_last_updated,
    :profile_last_updated_by,
    :receiving_emails_disabled,
    :registered_for_specific_event,
    :renewal_date_last_changed,
    :renewal_due,
    :status,
    :street_address,
    :subscription_source,
    :suspended_member,
    :terms_of_use_accepted,
    :total_donated,
    :url,
    :user_id,
    :zip,
    :is_app_admin?
  ]

  def is_paying?(member) do
    member.membership_level["Name"] in @paid_member_levels
  end

  def from_contact(contact) do
    member =
      contact
      |> map_main_values()
      |> map_field_values(contact)
      |> set_properties()

    struct(__MODULE__, member)
  end

  defp set_properties(member_map) do
    props = %{
      has_mail_box: Map.get(member_map, :has_mail_box) || false,
      has_mail_alias: Map.get(member_map, :has_mail_alias) || false,
      is_paying?: is_paying?(member_map),
      is_app_admin?: in_website_admin?(member_map.group_participation)
    }

    Map.merge(member_map, props)
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
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, @str_key_map[k], v) end)
  end

  defp map_field_values(member_map, contact) do
    contact
    |> Map.get("FieldValues")
    |> Enum.reduce(member_map, fn f, acc ->
      Map.put(acc, @str_key_map[f["FieldName"]], f["Value"])
    end)
  end
end
