defmodule Erlef.EventTypeTest do
  use Erlef.DataCase

  alias Erlef.Schema.EventType

  describe "changeset/2" do
    test "when params are valid" do
      cs = EventType.changeset(%EventType{}, %{name: "foo"})
      assert cs.valid? == true
      assert cs.errors == []
    end

    test "when params are invalid" do
      cs = EventType.changeset(%EventType{}, %{name: 1})
      assert cs.valid? == false

      assert cs.errors == [
               {:name, {"is invalid", [type: :string, validation: :cast]}}
             ]
    end

    test "when required params are missing" do
      cs = EventType.changeset(%EventType{}, %{foo: 1, bar: %{}})
      assert cs.valid? == false

      assert cs.errors == [
               {:name, {"can't be blank", [validation: :required]}}
             ]
    end

    test "get/1" do
      EventType.changeset(%EventType{}, %{name: "conference"}) |> Repo.insert!()
      EventType.get(:conference)
    end
  end
end
