defmodule Erlef.EventTypeTest do
  use Erlef.DataCase
  alias Erlef.Data.EventType

  describe "changeset/2" do
    test "when params are valid" do
      cs = EventType.changeset(%EventType{}, %{name: "foo", detail: "bar"})
      assert cs.valid? == true
      assert cs.errors == []
    end

    test "when params are invalid" do
      cs = EventType.changeset(%EventType{}, %{name: 1, detail: %{}})
      assert cs.valid? == false

      assert cs.errors == [
               {:name, {"is invalid", [type: :string, validation: :cast]}},
               {:detail, {"is invalid", [type: :string, validation: :cast]}}
             ]
    end

    test "when required params are missing" do
      cs = EventType.changeset(%EventType{}, %{foo: 1, bar: %{}})
      assert cs.valid? == false

      assert cs.errors == [
               {:name, {"can't be blank", [validation: :required]}},
               {:detail, {"can't be blank", [validation: :required]}}
             ]
    end
  end
end
