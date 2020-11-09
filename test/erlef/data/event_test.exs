defmodule Erlef.EventTest do
  use Erlef.DataCase

  alias Erlef.Data.Schema.Event

  describe "submission_submission_changeset/2" do
    test "when params are valid" do
      params = %{
        title: "Event Title",
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by: 123,
        url: "https://foo.bar/",
        organizer: "Organizer",
        event_type_id: Ecto.UUID.generate()
      }

      cs = Event.submission_changeset(%Event{}, params)
      assert cs.valid?
      assert cs.errors == []

      assert cs.changes ==
               params
               |> Map.put(:slug, "event-title")
               |> Map.put(:description, "<p>\nFull description</p>\n")
    end

    test "when optional params are valid" do
      params = %{
        title: "Event Title",
        event_type_id: Ecto.UUID.generate(),
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by: 123,
        url: "https://foo.bar/",
        organizer: "Organizer",
        organizer_brand_color: "#12345",
        organizer_brand_logo: "eh..."
      }

      cs = Event.submission_changeset(%Event{}, params)
      assert cs.valid?
      assert cs.errors == []

      assert cs.changes ==
               params
               |> Map.put(:slug, "event-title")
               |> Map.put(:description, "<p>\nFull description</p>\n")
    end

    test "when params are invalid" do
      cs = Event.submission_changeset(%Event{}, %{title: 1, description: %{}})
      refute cs.valid?

      exp_errors = [
        {:start, {"can't be blank", [validation: :required]}},
        {:end, {"can't be blank", [validation: :required]}},
        {:organizer, {"can't be blank", [validation: :required]}},
        {:url, {"can't be blank", [validation: :required]}},
        {:submitted_by, {"can't be blank", [validation: :required]}},
        {:event_type_id, {"can't be blank", [validation: :required]}},
        {:title, {"is invalid", [{:type, :string}, {:validation, :cast}]}},
        {:description, {"is invalid", [type: :string, validation: :cast]}}
      ]

      assert cs.errors == exp_errors
    end

    test "when required params are missing" do
      cs = Event.submission_changeset(%Event{}, %{foo: 1, bar: %{}})
      refute cs.valid?

      exp_errors = [
        {:title, {"can't be blank", [validation: :required]}},
        {:description, {"can't be blank", [validation: :required]}},
        {:start, {"can't be blank", [validation: :required]}},
        {:end, {"can't be blank", [validation: :required]}},
        {:organizer, {"can't be blank", [validation: :required]}},
        {:url, {"can't be blank", [validation: :required]}},
        {:submitted_by, {"can't be blank", [validation: :required]}},
        {:event_type_id, {"can't be blank", [validation: :required]}}
      ]

      assert exp_errors == cs.errors
    end
  end

  describe "approval_changeset/2" do
    test "when params are valid" do
      event = %Event{
        slug: "This should be generated",
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by: 123,
        url: "https://foo.bar/",
        organizer: "Organizer"
      }

      params = %{
        approved_by: 123
      }

      cs = Event.approval_changeset(event, params)
      assert cs.valid?
      assert cs.errors == []
      assert cs.changes.approved_at
      assert cs.changes.approved == true
    end

    test "when params are invalid" do
      event = %Event{
        slug: "This should be generated",
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by: 123,
        url: "https://foo.bar/",
        organizer: "Organizer"
      }

      params = %{
        approved_by: "eh"
      }

      cs = Event.approval_changeset(event, params)
      refute cs.valid?
      assert cs.errors == [{:approved_by, {"is invalid", [type: :integer, validation: :cast]}}]
    end
  end
end
