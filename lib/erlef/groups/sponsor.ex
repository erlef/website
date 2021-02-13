defmodule Erlef.Groups.Sponsor do
  @moduledoc false
  use Erlef.Schema

  schema "sponsors" do
    field(:active, :boolean, default: true)
    field(:logo, :string, virtual: true)
    field(:logo_url, :string)
    field(:is_founding_sponsor, :boolean, default: false)
    field(:name, :string)
    field(:url, :string)
    field(:created_by, Ecto.UUID)
    field(:updated_by, Ecto.UUID)

    timestamps()
  end

  @required [:name, :url, :logo_url, :created_by]
  @optional [:active, :is_founding_sponsor, :updated_by]
  @permitted @required ++ @optional

  @doc false
  def changeset(sponsor, attrs) do
    sponsor
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end

  @doc false
  def update_changeset(sponsor, attrs) do
    sponsor
    |> cast(attrs, @permitted)
    |> validate_required([:is_founding_sponsor, :updated_by])
  end
end
