defmodule Erlef.EventTest do
  use Erlef.DataCase
  alias Erlef.Data.Event

  describe "changeset/2" do
    test "when params are valid" do
      params = %{
        title: "Event Title",
        slug: "This should be generated",
        excerpt: "Short description",
        description: "Full description",
        start: DateTime.utc_now(),
        end: DateTime.utc_now(),
        submitted_by: 123,
        url: "https://foo.bar/",
        organizer: "Organizer"
      }

      cs = Event.changeset(%Event{}, params)
      assert cs.valid? == true
      assert cs.errors == []
      assert cs.changes.title == "event-title"
    end

    test "when params are invalid" do
      cs = Event.changeset(%Event{}, %{title: 1, description: %{}})
      assert cs.valid? == false

      exp_errors = [
        {:end, {"can't be blank", [validation: :required]}},
        {:excerpt, {"can't be blank", [validation: :required]}},
        {:organizer, {"can't be blank", [validation: :required]}},
        {:slug, {"can't be blank", [validation: :required]}},
        {:start, {"can't be blank", [validation: :required]}},
        {:submitted_by, {"can't be blank", [validation: :required]}},
        {:url, {"can't be blank", [validation: :required]}},
        {:description, {"is invalid", [type: :string, validation: :cast]}},
        {:title, {"is invalid", [type: :string, validation: :cast]}}
      ]

      assert cs.errors == exp_errors
    end

    test "when required params are missing" do
      cs = Event.changeset(%Event{}, %{foo: 1, bar: %{}})
      assert cs.valid? == false

      exp_errors = [
        {:description, {"can't be blank", [validation: :required]}},
        {:end, {"can't be blank", [validation: :required]}},
        {:excerpt, {"can't be blank", [validation: :required]}},
        {:organizer, {"can't be blank", [validation: :required]}},
        {:slug, {"can't be blank", [validation: :required]}},
        {:start, {"can't be blank", [validation: :required]}},
        {:submitted_by, {"can't be blank", [validation: :required]}},
        {:title, {"can't be blank", [validation: :required]}},
        {:url, {"can't be blank", [validation: :required]}}
      ]

      assert exp_errors == cs.errors
    end
  end
end
