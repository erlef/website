defmodule Erlef.Groups.Query do
  @moduledoc """
  Module for the group queries
  """

  import Ecto.Query, only: [from: 2]
  alias Erlef.Groups.{Volunteer, WorkingGroup}

  def all_board_members() do
    from(v in Volunteer,
      where: v.is_board_member == true
    )
  end

  @spec all_working_groups() :: Ecto.Query.t()
  def all_working_groups(), do: wg_query()

  @spec get_working_group_by_slug(slug :: String.t()) :: Ecto.Query.t()
  def get_working_group_by_slug(slug) do
    from(wg in wg_query(),
      where: wg.slug == ^slug
    )
  end

  defp wg_query() do
    from(wg in WorkingGroup,
      join: v in assoc(wg, :volunteers),
      join: c in assoc(wg, :chairs),
      preload: [volunteers: v, chairs: c]
    )
  end
end
