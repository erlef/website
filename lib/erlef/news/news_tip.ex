defmodule Erlef.News.NewsTip do
  @moduledoc false

  use Erlef.Schema

  alias Erlef.Accounts.Member

  @derive {Jason.Encoder,
           except: [:__meta__, :logs, :assigned_to, :created_by, :updated_by, :processed_by]}
  schema "news_tips" do
    field(:type, Ecto.Enum, values: [:announcement, :publication, :grant, :research, :other])
    field(:status, Ecto.Enum, values: [:queued, :in_progress, :processed])
    field(:who, :string)
    field(:what, :string)
    field(:at_when, :string)
    field(:at_where, :string)
    field(:why, :string)
    field(:how, :string)
    field(:flags, {:array, Ecto.Enum}, values: [:wont_process], default: [])
    field(:priority, :integer, default: 0)

    field(:additional_info, :string)
    field(:note, :string, virtual: true)

    embeds_many(:supporting_documents, SupportingDocument, on_replace: :delete) do
      @derive Jason.Encoder
      field(:url, :string)
      field(:mime, :string)
    end

    embeds_many(:notes, Note, on_replace: :delete) do
      @derive Jason.Encoder
      field(:text, :string)
      belongs_to(:created_by, Erlef.Accounts.Member)
    end

    embeds_many(:logs, Log, on_replace: :delete) do
      @derive Jason.Encoder
      field(:changes, :map)
      belongs_to(:changed_by, Erlef.Accounts.Member)
      field(:previous_version, :map)
    end

    belongs_to(:assigned_to, Erlef.Accounts.Member)
    belongs_to(:created_by, Erlef.Accounts.Member)
    belongs_to(:updated_by, Erlef.Accounts.Member)
    belongs_to(:processed_by, Erlef.Accounts.Member)

    timestamps()
  end

  @create_fields [
    :type,
    :who,
    :what,
    :at_when,
    :at_where,
    :why,
    :how,
    :additional_info,
    :created_by_id
  ]

  @create_required [
    :type,
    :who,
    :what,
    :at_when,
    :at_where,
    :status,
    :created_by_id
  ]

  @update_fields [
    :assigned_to_id,
    :status,
    :note,
    :processed_by_id,
    :updated_by_id,
    :flags,
    :priority
  ]

  @update_fields_required [:updated_by_id]

  @doc false
  def changeset(news_tip, attrs) do
    news_tip
    |> cast(attrs, @create_fields)
    |> put_change(:status, :queued)
    |> cast_embed(:supporting_documents, with: &supporting_documents_changeset/2)
    |> validate_required(@create_required)
  end

  @doc false
  def update_changeset(news_tip, attrs) do
    news_tip
    |> cast(attrs, @update_fields)
    |> add_log()
    |> maybe_add_note()
    |> validate_required(@update_fields_required)
  end

  def by_member(%Member{id: id}) do
    from(nt in __MODULE__,
      where: nt.created_by_id == ^id,
      order_by: nt.inserted_at
    )
  end

  defp supporting_documents_changeset(doc, attrs) do
    doc
    |> cast(attrs, [:url, :mime])
    |> validate_required([:url, :mime])
  end

  defp maybe_add_note(%{changes: %{note: text, updated_by_id: member_id}} = cs) do
    tip = cs.data

    note = %Erlef.News.NewsTip.Note{
      text: text,
      created_by_id: member_id
    }

    put_embed(cs, :notes, [note | tip.notes])
  end

  defp maybe_add_note(cs), do: cs

  defp add_log(cs) do
    tip = cs.data

    log = %Erlef.News.NewsTip.Log{
      changes: cs.changes,
      previous_version: cs.data,
      changed_by_id: cs.changes.updated_by_id
    }

    put_embed(cs, :logs, [log | tip.logs])
  end
end
