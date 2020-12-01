defmodule Erlef.WidlApricotTest do
  use ExUnit.Case, async: true

  alias Erlef.WildApricot

  describe "login/1" do
    test "when contact exists" do
      assert {:ok, _contact} = WildApricot.login("basic_member")
    end

    test "when contact does not exist" do
      assert {:error, _contact} = WildApricot.login("invalid")
    end
  end

  describe "get_contact/1" do
    test "when contact exists" do
      assert {:ok, _contact} = WildApricot.get_contact("basic_member")
    end

    test "when contact does not exist" do
      assert {:error, _contact} = WildApricot.get_contact("eh?")
    end
  end

  describe "get_contact_by_field_value/1" do
    test "when contact is found" do
      {:ok, contact} = WildApricot.get_contact("annual_member")

      %{"Value" => uuid} =
        Enum.find(contact["FieldValues"], fn f -> f["FieldName"] == "erlef_app_id" end)

      assert {:ok, ^contact} = WildApricot.get_contact_by_field_value("erlef_app_id", uuid)
    end

    test "when contact is not found" do
      assert {:error, :not_found} =
               WildApricot.get_contact_by_field_value("erlef_app_id", Ecto.UUID.generate())
    end

    test "when field name is malformed" do
      assert {:error, _} = WildApricot.get_contact_by_field_value("", Ecto.UUID.generate())
    end
  end

  describe "update_contact/2" do
    test "when contact is found" do
      {:ok, contact} = WildApricot.get_contact("basic_member")
      uuid = Ecto.UUID.generate()

      update = %{
        "Id" => contact["Id"],
        "FieldValues" => [%{"FieldName" => "erlef_app_id", "Value" => uuid}]
      }

      assert {:ok, contact} = WildApricot.update_contact(contact["Id"], update)
      assert Enum.find(contact["FieldValues"], fn f -> f["Value"] == uuid end)
    end

    test "when bar" do
      {:ok, contact} = WildApricot.get_contact("basic_member")
      uuid = Ecto.UUID.generate()

      update = %{
        "Id" => contact["Id"],
        "FieldValues" => [%{"FieldName" => "erlef_app_id", "Value" => uuid}]
      }

      assert {:error, _} = WildApricot.update_contact("does_not_exist", update)
    end
  end
end
