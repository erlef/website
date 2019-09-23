defmodule Erlef.WorkingGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_groups" do
    field(:name, :string)
    field(:slug, :string)
    field(:description, :string)
    field(:primary_contact_method, :string)
    field(:email, :string)
    field(:github, :string)
    field(:gcal_url, :string)
    field(:body, :string)
    field(:body_html, :string)
    field(:excerpt, :string)
    field(:excerpt_html, :string)
    field(:formed, :date)

    embeds_many(:members, Member, primary_key: false) do
      field(:id, :integer)
      field(:name, :string)
      field(:image, :string)
    end
  end

  @required_fields ~w(name slug description email github gcal_url formed primary_contact_method body body_html excerpt excerpt_html)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> cast_embed(:members, with: &member_changeset/2)
  end

  defp member_changeset(schema, params) do
    schema
    |> cast(params, [:name, :image])
  end
end
