defmodule Erlef.Accounts.Member do
  use Erlef.Schema

  @moduledoc """
  Erlef.Accounts.Member provides a schema and helper functions for working with erlef members.


  Members are a "concrete" representation of an associated external resource, namely wildapricot, 
  and as such it shou  ld be duly that this application is not the source of truth of members.

  The schema allows us to cache member attributes, such as the member's name. This is useful in the case of 
  quite wildapricot per their strict api rate limits. Additionally, this allows us to properly associate and 
  constraint other schemas within the system to a member; as well as keeping the rest of the application 
  completely ignorant in regards to wildapricot 

  See `Erlef.Accounts.External` for details on how fields are mapped between the two resources.
  """

  @paid_member_levels [
    :annual,
    :lifetime,
    :board,
    :fellow,
    :contributor
  ]

  @membership_level_str_map %{
    "Basic Membership" => :basic,
    "Annual Supporting Membership" => :annual,
    "Lifetime Supporting Membership" => :lifetime,
    "Board" => :board,
    "Fellow" => :fellow,
    "Managing and Contributing" => :contributor
  }

  @membership_level_map Map.new(@membership_level_str_map, fn {k, v} -> {v, k} end)

  @derive {Jason.Encoder, only: [:id]}
  schema "members" do
    field(:avatar, :map, virtual: true)
    field(:avatar_url, :string)
    field(:name, :string, redact: true)
    field(:first_name, :string, redact: true)
    field(:last_name, :string, redact: true)
    field(:email, :string, redact: true)
    field(:erlef_email_address, :string, redact: true)
    field(:roles, {:array, Ecto.Enum}, values: [:app_admin])
    field(:member_since, :date)
    field(:membership_enabled, :boolean)
    field(:membership_level, Ecto.Enum, values: Map.values(@membership_level_str_map))
    field(:suspended_member, :boolean, default: false)
    field(:terms_of_use_accepted, :boolean)
    field(:is_app_admin, :boolean, default: false)
    field(:is_archived, :boolean)
    field(:is_donor, :boolean)
    field(:has_email_box, :boolean, default: false)
    field(:has_email_alias, :boolean, default: false)
    field(:has_email_address, :boolean, default: false)
    field(:has_requested_slack_invite, :boolean, default: false)
    field(:requested_slack_invite_at, :utc_datetime)
    field(:deactivated_at, :utc_datetime)
    embeds_one(:external, Erlef.Accounts.External, on_replace: :update)
    timestamps()
  end

  @fields [
    :avatar_url,
    :name,
    :first_name,
    :last_name,
    :email,
    :erlef_email_address,
    :roles,
    :has_email_alias,
    :has_email_box,
    :has_email_address,
    :has_requested_slack_invite,
    :is_app_admin,
    :is_archived,
    :is_donor,
    :member_since,
    :membership_enabled,
    :membership_level,
    :requested_slack_invite_at,
    :suspended_member,
    :terms_of_use_accepted,
    :deactivated_at
  ]

  @required_fields [
    :name,
    :first_name,
    :last_name,
    :email,
    :roles,
    :has_email_alias,
    :has_email_box,
    :has_email_address,
    :is_app_admin,
    :is_archived,
    :is_donor,
    :member_since,
    :membership_enabled,
    :membership_level,
    :suspended_member,
    :terms_of_use_accepted
  ]

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, @fields)
    |> cast_embed(:external)
    |> validate_required(@required_fields)
    |> validate_email(:email)
    |> validate_email(:erlef_email_address)
  end

  def by_external_id(id) do
    from(m in __MODULE__,
      where: fragment("(external->>'id' = ?)", ^id)
    )
  end

  def is_paying?(%Member{membership_level: level}) when is_atom(level) do
    level in @paid_member_levels
  end

  def is_paying?(_), do: false

  def membership_level(%Member{membership_level: level}, humanize: true) do
    @membership_level_map[level]
  end
end
