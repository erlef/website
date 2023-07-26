defmodule Erlef.AcademicPapers do
  @moduledoc """
  Context responsible for managing Academic Papers
  """

  alias Erlef.AcademicPapers.Query
  alias Erlef.AcademicPapers.AcademicPaper

  @spec all() :: [AcademicPaper.t()]
  def all(), do: Query.published()

  @spec get(Ecto.UUID.t()) :: AcademicPaper.t()
  def get(id), do: Query.get(id)

  @spec create_academic_paper(params :: map()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def create_academic_paper(params) do
    new_params = normalize_params(params)

    %AcademicPaper{}
    |> change_academic_paper(new_params)
    |> Query.create()
  end

  @spec update_academic_paper(academic_paper :: AcademicPaper.t(), params :: map()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def update_academic_paper(%AcademicPaper{} = academic_paper, params) do
    new_params = normalize_params(params)

    academic_paper
    |> change_academic_paper(new_params)
    |> Query.update()
  end

  @spec delete_academic_paper(academic_paper :: AcademicPaper.t()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def delete_academic_paper(%AcademicPaper{} = academic_paper) do
    academic_paper
    |> change_academic_paper(%{deleted_at: DateTime.utc_now()})
    |> Query.update()
  end

  @spec change_academic_paper(academic_paper :: Ecto.Schema.t(), params :: map()) ::
          Ecto.Changeset.t()
  def change_academic_paper(%AcademicPaper{} = academic_paper, attrs \\ %{}),
    do: AcademicPaper.changeset(academic_paper, attrs)

  @spec unapproved_all() :: [AcademicPaper.t()]
  def unapproved_all(), do: Query.unpublished()

  @spec approve_academic_paper(academic_paper :: AcademicPaper.t(), params :: map()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def approve_academic_paper(%AcademicPaper{} = unapproved_academic_paper, params) do
    params0 = normalize_params(params)
    new_params = Map.put(params0, "published_at", DateTime.utc_now())

    unapproved_academic_paper
    |> change_academic_paper(new_params)
    |> Query.update()
  end

  # Private Internal Functions

  defp normalize_params(%{"technologies" => _val} = params), do: params

  defp normalize_params(params), do: Map.put(params, "technologies", "")
end
