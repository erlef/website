defmodule Erlef.MemberTest do
  use Erlef.DataCase

  alias Erlef.Accounts
  alias Erlef.Accounts.Member

  @valid_attrs %{
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

  describe "changeset/2" do
    test "when attrs are valid" do
      cs = Member.changeset(%Member{}, @valid_attrs)
      assert cs.valid?
    end

    test "when attrs are invalid" do
      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :email, "default_user"))
      refute cs.valid?
      assert cs.errors == [email: {"email is invalid.", []}]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :external, %{id: 0, source: :eh}))
      refute cs.valid?
      refute cs.changes.external.valid?
      assert [id: {"is invalid", _}, source: {"is invalid", _}] = cs.changes.external.errors

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :first_name, nil))
      refute cs.valid?
      assert cs.errors == [first_name: {"can't be blank", [validation: :required]}]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :last_name, nil))
      refute cs.valid?
      assert cs.errors == [last_name: {"can't be blank", [validation: :required]}]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :name, nil))
      refute cs.valid?
      assert cs.errors == [name: {"can't be blank", [validation: :required]}]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :has_email_address, :falsey))
      refute cs.valid?

      assert cs.errors == [
               has_email_address: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}
             ]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :has_email_alias, :truthy))
      refute cs.valid?

      assert cs.errors == [
               has_email_alias: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}
             ]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :has_email_box, "no"))
      refute cs.valid?

      assert cs.errors == [
               has_email_box: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}
             ]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :is_app_admin, 0))
      refute cs.valid?

      assert cs.errors == [
               is_app_admin: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}
             ]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :is_archived, "no"))
      refute cs.valid?
      assert cs.errors == [is_archived: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :suspended_member, nil))
      refute cs.valid?
      assert cs.errors == [suspended_member: {"can't be blank", [validation: :required]}]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :terms_of_use_accepted, "check"))
      refute cs.valid?

      assert cs.errors == [
               terms_of_use_accepted: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}
             ]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :is_donor, "no"))
      refute cs.valid?
      assert cs.errors == [is_donor: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :membership_enabled, :no))
      refute cs.valid?

      assert cs.errors == [
               membership_enabled: {"is invalid", [{:type, :boolean}, {:validation, :cast}]}
             ]

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :membership_level, :root))
      refute cs.valid?

      assert [
               membership_level:
                 {"is invalid",
                  [type: {:parameterized, _}, validation: :inclusion, enum: [_ | _]]}
             ] = cs.errors

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :roles, :root))
      refute cs.valid?

      assert [roles: {"is invalid", [type: {:array, {:parameterized, _}}, validation: :cast]}] =
               cs.errors

      cs = Member.changeset(%Member{}, Map.put(@valid_attrs, :member_since, "02/07/2021"))
      refute cs.valid?
      assert cs.errors == [member_since: {"is invalid", [type: :date, validation: :cast]}]
    end
  end

  describe "is_paying?" do
    test "when contact is basic" do
      {:ok, contact} = Erlef.Test.WildApricot.get_contact("basic_member")
      member = Accounts.to_member(contact, %{from: :wildapricot})
      refute Member.is_paying?(member)
    end

    test "when contact is annual supporting member" do
      {:ok, contact} = Erlef.Test.WildApricot.get_contact("annual_member")
      member = Accounts.to_member(contact, %{from: :wildapricot})
      assert Member.is_paying?(member)
    end

    test "when contact is lifetime member" do
      {:ok, contact} = Erlef.Test.WildApricot.get_contact("lifetime_member")
      member = Accounts.to_member(contact, %{from: :wildapricot})
      assert Member.is_paying?(member)
    end

    test "when contact is a contribtor" do
      {:ok, contact} = Erlef.Test.WildApricot.get_contact("wg_chair")
      member = Accounts.to_member(contact, %{from: :wildapricot})
      assert Member.is_paying?(member)
    end

    test "when contact is a fellow" do
      {:ok, contact} = Erlef.Test.WildApricot.get_contact("fellow_member")
      member = Accounts.to_member(contact, %{from: :wildapricot})
      assert Member.is_paying?(member)
    end
  end

  describe "membership_level/2" do
    test "when member is basic" do
      assert Member.membership_level(%Member{membership_level: :basic}, humanize: true) ==
               "Basic Membership"
    end

    test "when member is annual" do
      assert Member.membership_level(%Member{membership_level: :annual}, humanize: true) ==
               "Annual Supporting Membership"
    end

    test "when member is lifetime" do
      assert Member.membership_level(%Member{membership_level: :lifetime}, humanize: true) ==
               "Lifetime Supporting Membership"
    end

    test "when member is board" do
      assert Member.membership_level(%Member{membership_level: :board}, humanize: true) == "Board"
    end

    test "when member is fellow" do
      assert Member.membership_level(%Member{membership_level: :fellow}, humanize: true) ==
               "Fellow"
    end
  end
end
