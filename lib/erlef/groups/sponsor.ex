defmodule Erlef.Groups.Sponsor do
  @moduledoc false
  use Erlef.Schema

  schema "sponsors" do
    field(:logo, :string, virtual: true)
    field(:logo_url, :string)
    field(:is_founding_sponsor, :boolean, default: false)
    field(:name, :string)
    field(:url, :string)

    timestamps()
  end

  @required [:name, :url, :logo_url]
  @optional [:is_founding_sponsor]
  @permitted @required ++ @optional

  @doc false
  def changeset(sponsor, attrs) do
    sponsor
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
