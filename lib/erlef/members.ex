defmodule Erlef.Members do
  @moduledoc """
  Erlef.Members context module
  """
  alias Erlef.Data.Schema.Event
  alias Erlef.Data.Repo

  def new_event, do: Event.new_changeset(%Event{}, %{})

  def submit_event(params) do
    cs = Event.submission_changeset(%Event{}, params)

    case cs.valid? do
      true ->
        Repo.insert(cs)

      false ->
        {:error, cs}
    end
  end
end
