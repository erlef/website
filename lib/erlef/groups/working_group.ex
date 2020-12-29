defmodule Erlef.Groups.WorkingGroup do
  @moduledoc """
  Erlef.WorkingGroup schema
  """

  use Erlef.Schema
  alias Erlef.Groups.{WorkingGroupChair, WorkingGroupVolunteer, Volunteer}

  schema "working_groups" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:formed, :date)
    field(:proposal, :string)
    field(:proposal_html, :string)

    # field(:chairs, :array, virtual: true)

    embeds_one(:meta, Meta, primary_key: false, on_replace: :update) do
      field(:email, :string)
      field(:github, :string)
      field(:gcal_url, :string)
    end

    many_to_many(:chairs, Volunteer,
      join_through: WorkingGroupChair,
      on_delete: :delete_all
    )

    many_to_many(:volunteers, Volunteer,
      join_through: WorkingGroupVolunteer,
      on_delete: :delete_all
    )
  end

  @required_fields [:name, :slug, :description, :formed, :proposal]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> cast_embed(:meta, with: &meta_changeset/2)
    |> validate_required(@required_fields)
    |> maybe_gen_html()
  end

  defp maybe_gen_html(%{changes: %{proposal: proposal}} = cs) do
    {:ok, html, _} = Earmark.as_html(proposal)
    put_change(cs, :proposal_html, html)
  end

  defp maybe_gen_html(cs), do: cs

  defp meta_changeset(schema, params) do
    schema
    |> cast(params, [:github, :gcal_url, :email])
  end
end
