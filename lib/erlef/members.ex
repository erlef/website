defmodule Erlef.Members do
  @moduledoc """
  Erlef.Members context module
  """
  alias Erlef.Data.Schema.Event
  alias Erlef.Data.Repo

  @spec new_event() :: Ecto.Changeset.t()
  def new_event, do: Event.new_changeset(%Event{}, %{})

  @spec submit_event(params :: map()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
  def submit_event(params) do
    %Ecto.Changeset{} = cs = Event.submission_changeset(%Event{}, params)

    case cs.valid? do
      true ->
        Repo.insert(cs)

      false ->
        {:error, cs}
    end
  end
end
