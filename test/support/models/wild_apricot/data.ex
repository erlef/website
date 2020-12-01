defmodule Erlef.Test.WildApricot.Data do
  @moduledoc false

  def contact_data(specified) do
    default = default_contact_data()

    new = Map.merge(default, specified)

    case Map.has_key?(specified, "FieldValues") do
      true ->
        specified_fields = Enum.map(specified["FieldValues"], & &1["FieldName"])
        without = Enum.reject(default["FieldValues"], &(&1["FieldName"] in specified_fields))
        Map.put(new, "FieldValues", specified["FieldValues"] ++ without)

      false ->
        new
    end
  end

  defp default_contact_data() do
    %{
      "DisplayName" => "Default Member Name",
      "Email" => "user@foo.bar",
      "FieldValues" => [
        %{"FieldName" => "Archived", "SystemCode" => "IsArchived", "Value" => false},
        %{"FieldName" => "Donor", "SystemCode" => "IsDonor", "Value" => false},
        %{
          "FieldName" => "Event registrant",
          "SystemCode" => "IsEventAttendee",
          "Value" => false
        },
        %{"FieldName" => "Member", "SystemCode" => "IsMember", "Value" => true},
        %{
          "FieldName" => "Suspended member",
          "SystemCode" => "IsSuspendedMember",
          "Value" => false
        },
        %{
          "FieldName" => "Event announcements",
          "SystemCode" => "ReceiveEventReminders",
          "Value" => true
        },
        %{
          "FieldName" => "Member emails and newsletters",
          "SystemCode" => "ReceiveNewsletters",
          "Value" => true
        },
        %{
          "FieldName" => "Email delivery disabled",
          "SystemCode" => "EmailDisabled",
          "Value" => false
        },
        %{
          "FieldName" => "Receiving emails disabled",
          "SystemCode" => "RecievingEMailsDisabled",
          "Value" => false
        },
        %{"FieldName" => "Balance", "SystemCode" => "Balance", "Value" => 0.0},
        %{
          "FieldName" => "Total donated",
          "SystemCode" => "TotalDonated",
          "Value" => 0.0
        },
        %{
          "FieldName" => "Registered for specific event",
          "SystemCode" => "RegistredForEvent",
          "Value" => nil
        },
        %{
          "FieldName" => "Profile last updated",
          "SystemCode" => "LastUpdated",
          "Value" => "2019-05-30T08:29:02-07:00"
        },
        %{
          "FieldName" => "Profile last updated by",
          "SystemCode" => "LastUpdatedBy",
          "Value" => 00_000_001
        },
        %{
          "FieldName" => "Creation date",
          "SystemCode" => "CreationDate",
          "Value" => "2019-05-16T08:57:28-07:00"
        },
        %{
          "FieldName" => "Last login date",
          "SystemCode" => "LastLoginDate",
          "Value" => "2020-11-27T10:39:57-08:00"
        },
        %{
          "FieldName" => "Administrator role",
          "SystemCode" => "AdminRole",
          "Value" => []
        },
        %{
          "FieldName" => "Notes",
          "SystemCode" => "Notes",
          "Value" =>
            "Membership approved on 2019-05-30 by Admin\n\nRenewal processed on 2020-05-16.\nMembership is effective from 2020-05-16 until 2021-05-16"
        },
        %{
          "FieldName" => "Terms of use accepted",
          "SystemCode" => "SystemRulesAndTermsAccepted",
          "Value" => true
        },
        %{
          "FieldName" => "Subscription source",
          "SystemCode" => "SubscriptionSource",
          "Value" => []
        },
        %{"FieldName" => "User ID", "SystemCode" => "MemberId", "Value" => nil},
        %{
          "FieldName" => "First name",
          "SystemCode" => "FirstName",
          "Value" => "Basic"
        },
        %{
          "FieldName" => "Last name",
          "SystemCode" => "LastName",
          "Value" => "Member"
        },
        %{
          "FieldName" => "Organization",
          "SystemCode" => "Organization",
          "Value" => ""
        },
        %{
          "FieldName" => "Email",
          "SystemCode" => "Email",
          "Value" => "default_user@foo.bar"
        },
        %{"FieldName" => "Phone", "SystemCode" => "Phone", "Value" => ""},
        %{
          "FieldName" => "Avatar",
          "SystemCode" => "custom-11017726",
          "Value" => %{
            "Id" => "xxxxxxxx.png",
            "Url" => "https://api.wildapricot.org/v2.1/accounts/292325/Pictures/xxxxxxxx.png"
          }
        },
        %{
          "FieldName" => "Privacy Policy",
          "SystemCode" => "custom-11017729",
          "Value" => false
        },
        %{
          "FieldName" => "Member role",
          "SystemCode" => "MemberRole",
          "Value" => nil
        },
        %{
          "FieldName" => "Member since",
          "SystemCode" => "MemberSince",
          "Value" => "2019-05-30T08:29:02-07:00"
        },
        %{
          "FieldName" => "Renewal due",
          "SystemCode" => "RenewalDue",
          "Value" => "2021-05-16T00:00:00"
        },
        %{
          "FieldName" => "Membership level ID",
          "SystemCode" => "MembershipLevelId",
          "Value" => 1_234_567
        },
        %{
          "FieldName" => "Access to profile by others",
          "SystemCode" => "AccessToProfileByOthers",
          "Value" => true
        },
        %{
          "FieldName" => "Renewal date last changed",
          "SystemCode" => "RenewalDateLastChanged",
          "Value" => "2020-05-16T01:01:04-07:00"
        },
        %{
          "FieldName" => "Level last changed",
          "SystemCode" => "LevelLastChanged",
          "Value" => "2019-05-16T08:57:28-07:00"
        },
        %{"FieldName" => "Bundle ID", "SystemCode" => "BundleId", "Value" => nil},
        %{
          "FieldName" => "Membership status",
          "SystemCode" => "Status",
          "Value" => %{
            "Id" => 1,
            "Label" => "Active",
            "Position" => 0,
            "SelectedByDefault" => false,
            "Value" => "Active"
          }
        },
        %{
          "FieldName" => "Membership enabled",
          "SystemCode" => "MembershipEnabled",
          "Value" => true
        },
        %{
          "FieldName" => "Group participation",
          "SystemCode" => "Groups",
          "Value" => []
        },
        %{
          "FieldName" => "Country",
          "SystemCode" => "custom-11072782",
          "Value" => nil
        },
        %{
          "FieldName" => "Street address",
          "SystemCode" => "custom-11072783",
          "Value" => nil
        },
        %{"FieldName" => "City", "SystemCode" => "custom-11072784", "Value" => nil},
        %{"FieldName" => "Zip", "SystemCode" => "custom-11072785", "Value" => nil},
        %{
          "FieldName" => "has_email_alias",
          "SystemCode" => "custom-12523891",
          "Value" => nil
        },
        %{
          "FieldName" => "has_email_box",
          "SystemCode" => "custom-12523892",
          "Value" => nil
        },
        %{
          "FieldName" => "erlef_email_address",
          "SystemCode" => "custom-12523894",
          "Value" => nil
        },
        %{
          "FieldName" => "erlef_app_id",
          "SystemCode" => "custom-12523894",
          "Value" => nil
        }
      ],
      "FirstName" => "Basic",
      "Id" => nil,
      "IsAccountAdministrator" => false,
      "LastName" => "Member",
      "MembershipEnabled" => true,
      "MembershipLevel" => nil,
      "Organization" => "",
      "ProfileLastUpdated" => "2019-05-30T08:29:02-07:00",
      "Status" => "Active",
      "TermsOfUseAccepted" => true,
      "Url" => "https://api.wildapricot.org/v2.1/accounts/010101/Contacts/1234567"
    }
  end
end
