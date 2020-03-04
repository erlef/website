defmodule Erlef.Events do
  @moduledoc false

  alias Erlef.Data.Query.Event, as: Query
  alias Erlef.Data.Schema.Event
  alias Erlef.Data.Repo

  @spec approve(Ecto.UUID.t(), map()) ::
          {:ok, Erlef.Data.Schema.Event} | {:error, Ecto.Changeset.t()}
  def approve(id, params) do
    event = Query.get(id)

    event
    |> Event.approval_changeset(params)
    |> Repo.update()
  end
end
