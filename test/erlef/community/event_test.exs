defmodule Erlef.EventTest do
  use Erlef.DataCase

  alias Erlef.Community.Event

  describe "submission_submission_changeset/2" do
    test "when params are valid" do
      params = %{
        title: "Event Title",
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by_id: Ecto.UUID.generate(),
        url: "https://foo.bar/",
        organizer: "Organizer",
        type: :meetup
      }

      cs = Event.submission_changeset(%Event{}, params)
      assert cs.valid?
      assert cs.errors == []

      assert cs.changes == Map.put(params, :description, "<p>\nFull description</p>\n")
    end

    test "when optional params are valid" do
      params = %{
        title: "Event Title",
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by_id: Ecto.UUID.generate(),
        url: "https://foo.bar/",
        organizer: "Organizer",
        organizer_brand_color: "#12345",
        organizer_brand_logo: "eh...",
        type: :conference
      }

      cs = Event.submission_changeset(%Event{}, params)
      assert cs.valid?
      assert cs.errors == []

      assert cs.changes == Map.put(params, :description, "<p>\nFull description</p>\n")
    end

    test "when params are invalid" do
      cs = Event.submission_changeset(%Event{}, %{title: 1, description: %{}})
      refute cs.valid?

      exp_errors = [
        {:start, {"can't be blank", [validation: :required]}},
        {:end, {"can't be blank", [validation: :required]}},
        {:organizer, {"can't be blank", [validation: :required]}},
        {:url, {"can't be blank", [validation: :required]}},
        {:type, {"can't be blank", [validation: :required]}},
        {:submitted_by_id, {"can't be blank", [validation: :required]}},
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
        {:type, {"can't be blank", [validation: :required]}},
        {:submitted_by_id, {"can't be blank", [validation: :required]}}
      ]

      assert exp_errors == cs.errors
    end
  end

  describe "approval_changeset/2" do
    test "when params are valid" do
      event = %Event{
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by_id: Ecto.UUID.generate(),
        url: "https://foo.bar/",
        organizer: "Organizer",
        type: :hackathon
      }

      params = %{
        approved_by_id: Ecto.UUID.generate()
      }

      cs = Event.approval_changeset(event, params)
      assert cs.valid?
      assert cs.errors == []
      assert cs.changes.approved_at
      assert cs.changes.approved == true
    end

    test "when params are invalid" do
      event = %Event{
        description: "Full description",
        start: Date.utc_today(),
        end: Date.utc_today(),
        submitted_by: Ecto.UUID.generate(),
        url: "https://foo.bar/",
        organizer: "Organizer",
        type: :eh
      }

      params = %{
        approved_by_id: "eh"
      }

      cs = Event.approval_changeset(event, params)
      refute cs.valid?
      assert cs.errors == [{:approved_by_id, {"Approved by is invalid. Not a valid UUID.", []}}]
    end
  end
end
