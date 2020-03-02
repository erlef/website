defmodule Erlef.Members do
  @moduledoc """
  Erlef.Members context module
  """

  def new_event, do: Erlef.Data.Event.new_changeset(%Erlef.Data.Event{}, %{})

  def submit_event(params) do
    cs = Erlef.Data.Event.submission_changeset(%Erlef.Data.Event{}, params)

    case cs.valid? do
      true ->
        Erlef.Data.Repo.insert(cs)

      false ->
        {:error, cs}
    end
  end
end
