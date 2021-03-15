defmodule Erlef.Community.Query do
  @moduledoc """
  Module for the event queries
  """
  import Ecto.Query, only: [from: 2]

  alias Erlef.Community.Event
  alias Erlef.Repo

  @doc """
  Returns a event given a valid id
  """
  @spec get_event(id :: Ecto.UUID.t()) :: Event.t() | nil
  def get_event(id) do
    q = from(e in Event,
      join: m in assoc(e, :submitted_by),
      left_join: a in assoc(e, :approved_by),
      where: e.id == ^id,
      preload: [submitted_by: m, approved_by: a]
    )
    Repo.one(q)
  end

  @doc """
  Returns a event by slug.
  """
  @spec get_event_by_slug(slug :: String.t()) :: Event.t() | nil
  def get_event_by_slug(slug) do
    from(p in Event,
      where: p.slug == ^slug,
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Returns all approved events
  """
  @spec approved_events() :: [Event.t()]
  def approved_events() do
    from(p in Event,
      where: p.approved,
      where: p.start >= ^Date.utc_today(),
      order_by: [p.start, p.title]
    )
    |> Repo.all()
  end

  @doc """
  Returns all unapproved events
  """
  @spec unapproved_events() :: [Event.t()]
  def unapproved_events() do
    from(p in Event,
      where: p.approved == false,
      order_by: [p.inserted_at]
    )
    |> Repo.all()
  end

  @spec unapproved_events_count() :: [Event.t()]
  def unapproved_events_count() do
    from(p in Event,
      where: p.approved == false,
      select: count(p.id)
    )
    |> Repo.one()
  end
end
