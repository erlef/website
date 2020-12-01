defmodule Erlef.MemberTest do
  use ExUnit.Case, async: true

  alias Erlef.Accounts.Member

  describe "get/1" do
    test "when id is uuid and contact is found" do
      {:ok, contact} = Erlef.WildApricot.get_contact("annual_member")

      %{"Value" => uuid} =
        Enum.find(contact["FieldValues"], fn f -> f["FieldName"] == "erlef_app_id" end)

      {:ok, _member} = Member.get(uuid)
    end

    test "when id is uuid and contact is not found" do
      {:error, _} = Member.get(Ecto.UUID.generate())
    end

    test "when id is not a uuid and contact is found" do
      {:ok, %Member{}} = Member.get("basic_member")
    end

    test "when id is not a uuid and contact is not found" do
      {:error, :not_found} = Member.get("eh?")
    end

    test "when id is malformed" do
      {:error, _} = Member.get("")
    end
  end

  describe "update/2" do
    test "valid" do
      {:ok, %Member{} = member} = Member.get("basic_member")

      uuid = Ecto.UUID.generate()

      {:ok, %Member{} = member} = Member.update(member, %{id: uuid})

      assert ^uuid = member.id

      {:ok, %Member{}} = Member.get(uuid)
    end

    test "invalid" do
      {:ok, %Member{} = member} = Member.get("basic_member")

      uuid = Ecto.UUID.generate()

      {:error, _} = Member.update(%{member | wild_apricot_id: "eh?"}, %{id: uuid})
    end
  end

  test "from_contact/1" do
    {:ok, contact} = Erlef.WildApricot.get_contact("admin")
    member = Member.from_contact(contact)
    assert member.is_app_admin?
  end
end
