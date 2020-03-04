defmodule Erlef.Events do
  @moduledoc false

  @spec approve(Ecto.UUID.t(), map()) ::
          {:ok, Erlef.Data.Schema.Event} | {:error, Ecto.Changeset.t()}
  def approve(id, params) do
    event = Erlef.Data.Query.Event.get(id)

    event
    |> Erlef.Data.Schema.Event.approval_changeset(params)
    |> Erlef.Data.Repo.update()
  end
end
