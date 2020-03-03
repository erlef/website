defmodule Erlef.Members do
  @moduledoc """
  Erlef.Members context module
  """

  def new_event, do: Erlef.Data.Schema.Event.new_changeset(%Erlef.Data.Schema.Event{}, %{})

  def submit_event(params) do
    cs = Erlef.Data.Schema.Event.submission_changeset(%Erlef.Data.Schema.Event{}, params)

    case cs.valid? do
      true ->
        Erlef.Data.Repo.insert(cs)

      false ->
        {:error, cs}
    end
  end
end
