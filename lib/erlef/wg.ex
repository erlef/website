defmodule Erlef.WG do
  @moduledoc """
    Erlef.WG
  """

  defstruct name: "",
            slug: "",
            description: "",
            email: nil,
            formed: nil,
            github: nil,
            gcal_url: nil,
            primary_contact_method: nil,
            members: []

  @type t :: map()

  @group_list Application.get_env(:erlef, :working_groups)

  @group_map Enum.reduce(@group_list, %{}, fn group, acc ->
               Map.put(acc, group.slug, group)
             end)

  @spec all :: [t]
  def all do
    @group_list
  end

  @spec fetch(String.t()) :: t | nil
  def fetch(slug) do
    struct(__MODULE__, @group_map[slug])
  end
end
