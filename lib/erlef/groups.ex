defmodule Erlef.Groups do
  @moduledoc """
  Erlef.Groups context
  """

  alias Erlef.Repo.ETS
  alias Erlef.Groups.WorkingGroup

  def all_working_groups(), do: ETS.all(WorkingGroup)

  def get_working_group_by_slug(slug) do
    case ETS.get_by(WorkingGroup, slug: slug) do
      %{slug: ^slug} = post -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end
end
