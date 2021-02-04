defmodule Erlef.AccountsTest do
  use Erlef.DataCase

  alias Erlef.Accounts
  alias Erlef.Accounts.Member

  describe "members" do
    alias Erlef.Accounts.Member

    @valid_attrs %{
      deactivated_at: nil,
      email: "default_user@foo.bar",
      external: %{id: "0", source: :wildapricot},
      first_name: "Joe",
      has_email_address: false,
      has_email_alias: false,
      has_email_box: false,
      is_app_admin: true,
      member_since: Date.utc_today(),
      is_archived: false,
      is_donor: false,
      is_paying: false,
      last_name: "Armstrong",
      membership_enabled: true,
      membership_level: :lifetime,
      name: "Joe Armstrong",
      roles: [:app_admin],
      suspended_member: false,
      terms_of_use_accepted: true
    }

    @update_attrs %{
      roles: [],
      deactivated_at: "2011-05-18T15:01:01Z"
    }

    @invalid_attrs %{
      deactivated_at: nil,
      email: "default_user",
      external: %{id: 1, source: :acme},
      first_name: nil,
      has_email_address: 0,
      has_email_alias: 0,
      has_email_box: 0,
      is_app_admin: "no",
      member_since: "02/07/2021",
      is_archived: :falsey,
      is_donor: :no,
      last_name: nil,
      membership_enabled: "nope",
      membership_level: :root,
      name: nil,
      roles: [:root],
      suspended_member: "no",
      terms_of_use_accepted: "off"
    }

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_member()

      member
    end

    test "get_member/1 returns the member with given id" do
      member = member_fixture()
      assert Accounts.get_member(member.id) == member
    end

    test "get_member_by_external_id/1 returns the member with given id" do
      member = member_fixture()
      assert Accounts.get_member_by_external_id(member.external.id) == member
      {int, _} = Integer.parse(member.external.id)
      assert Accounts.get_member_by_external_id(int) == member
    end

    test "get_member/1 returns nil for unknown member" do
      assert Accounts.get_member(Ecto.UUID.generate()) == nil
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Accounts.get_member!(member.id) == member
    end

    test "get_member!/1 raises when id for unknown member is given" do
      assert_raise Ecto.NoResultsError, fn ->
        assert Accounts.get_member!(Ecto.UUID.generate())
      end
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = _member} = Accounts.create_member(@valid_attrs)
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Accounts.update_member(member, @update_attrs)
      assert member.roles == []
      assert member.deactivated_at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_member(member, @invalid_attrs)
      assert member == Accounts.get_member!(member.id)
    end

    #   describe "from_contact/1" do
    #     test "when contact is basic" do
    #       {:ok, contact} = Erlef.Test.WildApricot.get_contact("basic_member")
    #       member = Member.from_contact(contact)
    #       refute member.is_app_admin
    #     end

    #     test "when contact has unrecognized group values" do
    #       {:ok, contact} = Erlef.Test.WildApricot.get_contact("basic_member")

    #       new_fv = %{
    #         "FieldName" => "Group participation",
    #         "SystemCode" => "Groups",
    #         "Value" => [
    #           %{"Id" => "654321", "Label" => "Eh?"}
    #         ]
    #       }

    #       member = Member.from_contact(Map.put(contact, "FieldValues", [new_fv]))
    #       assert member.roles == []
    #     end

    #     test "when contact admin" do
    #       {:ok, contact} = Erlef.Test.WildApricot.get_contact("admin")
    #       member = Member.from_contact(contact)
    #       assert member.is_app_admin
    #     end

    #     test "when contact is empty" do
    #       member = Member.from_contact(%{})
    #       assert member.is_app_admin
    #     end
    #   end

    #   describe "params_from_contact/1" do
    #     test "when contact is basic" do
    #       {:ok, contact} = Erlef.Test.WildApricot.get_contact("basic_member")
    #       member = Member.params_from_contact(contact)
    #       refute member.is_app_admin
    #     end

    #     test "when contact admin" do
    #       {:ok, contact} = Erlef.Test.WildApricot.get_contact("admin")
    #       member = Member.params_from_contact(contact)
    #       assert member.is_app_admin
    #     end

    #     test "when contact is empty" do
    #       member = Member.params_from_contact(%{})
    #       assert member.is_app_admin
    #     end
    #   end
  end
end
