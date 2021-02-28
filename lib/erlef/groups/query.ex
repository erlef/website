defmodule Erlef.Groups.Query do
  @moduledoc """
  Module for the group queries
  """

  import Ecto.Query, only: [from: 2]

  alias Erlef.Groups.{
    Volunteer,
    WorkingGroup,
    WorkingGroupChair,
    WorkingGroupReport,
    WorkingGroupVolunteer
  }

  def all_board_members() do
    from(v in Volunteer,
      where: v.is_board_member == true
    )
  end

  @spec all_working_groups() :: Ecto.Query.t()
  def all_working_groups(), do: wg_query()

  @spec get_wg_by_slug(slug :: String.t()) :: Ecto.Query.t()
  def get_wg_by_slug(slug) do
    from(wg in wg_query(),
      where: wg.slug == ^slug
    )
  end

  @spec get_wg_by_id(id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def get_wg_by_id(id) do
    from(wg in wg_query(),
      where: wg.id == ^id
    )
  end

  @spec get_wg_volunteer(wg_id :: Ecto.UUID.t(), id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def get_wg_volunteer(wg_id, volunteer_id) do
    from(wgv in WorkingGroupVolunteer,
      join: wg in WorkingGroup,
      on: wg.id == wgv.working_group_id,
      left_join: v in Volunteer,
      on: v.id == wgv.volunteer_id,
      where: wgv.working_group_id == ^wg_id and wgv.volunteer_id == ^volunteer_id
    )
  end

  @spec get_wg_chair(wg_id :: Ecto.UUID.t(), id :: Ecto.UUID.t()) :: Ecto.Query.t()
  def get_wg_chair(wg_id, volunteer_id) do
    from(wgc in WorkingGroupChair,
      join: wg in WorkingGroup,
      on: wg.id == wgc.working_group_id,
      left_join: v in Volunteer,
      on: v.id == wgc.volunteer_id,
      where: wgc.working_group_id == ^wg_id and wgc.volunteer_id == ^volunteer_id
    )
  end

  @spec get_volunteer_by_member_id(Ecto.UUID.t()) :: Volunteer.t()
  def get_volunteer_by_member_id(id) do
    from(v in Volunteer,
      join: wg in assoc(v, :working_groups),
      left_join: wgc in assoc(wg, :chairs),
      where: v.member_id == ^id,
      preload: [working_groups: {wg, chairs: wgc}]
    )
  end

  @spec get_wg_report_by_member_id(Ecto.UUID.t()) :: Volunteer.t()
  def get_wg_report_by_member_id(id) do
    from(r in WorkingGroupReport,
      where: r.member_id == ^id
    )
  end

  defp wg_query() do
    from(wg in WorkingGroup,
      left_join: v in assoc(wg, :volunteers),
      left_join: c in assoc(wg, :chairs),
      where: wg.active == true,
      preload: [volunteers: v, chairs: c]
    )
  end
end
