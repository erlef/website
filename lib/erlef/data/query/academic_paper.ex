defmodule Erlef.Data.Query.AcademicPaper do
  @moduledoc """
  Module for the academic paper queries
  """
  import Ecto.Query, only: [from: 2]

  alias Erlef.Data.Schema.AcademicPaper
  alias Erlef.Data.Repo

  @doc """
  Returns all active academic papers. Used for admin functionality
  """
  @spec all(repo :: Ecto.Repo.t()) :: [AcademicPaper.t()]
  def all(repo \\ Repo) do
    from(p in AcademicPaper,
      where: is_nil(p.deleted_at),
      order_by: [p.original_publish_date, p.title]
    ) |> repo.all()
  end

  @doc """
  Returns a academic paper by id. Used for admin functionality
  """
  @spec get(id :: binary(), repo :: Ecto.Repo.t()) :: AcademicPaper.t() | nil
  def get(id, repo \\ Repo) do
    from(p in AcademicPaper,
      where: is_nil(p.deleted_at),
      where: p.id == ^id
    ) |> repo.one()
  end

  @doc """
  Returns all active published academic papers
  """
  @spec published(repo :: Ecto.Repo.t()) :: [AcademicPaper.t()]
  def published(repo \\ Repo) do
    from(p in AcademicPaper,
      where: is_nil(p.deleted_at),
      where: not is_nil(p.published_at),
      order_by: [p.original_publish_date, p.title]
    ) |> repo.all()
  end

  @doc """
  Returns all active unpublished academic papers, Used for admin functionality
  """
  @spec unpublished(repo :: Ecto.Repo.t()) :: [AcademicPaper.t()]
  def unpublished(repo \\ Repo) do
    from(p in AcademicPaper,
      where: is_nil(p.deleted_at),
      where: is_nil(p.published_at),
      order_by: [p.original_publish_date, p.title]
    ) |> repo.all()
  end

  @doc """
  Creates a new academic paper. Used for admin functionality
  """
  @spec create(params :: map(), repo :: Ecto.Repo.t()) :: {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def create(params, repo \\ Repo) do
    %AcademicPaper{}
    |> AcademicPaper.changeset(params)
    |> case do
         %Ecto.Changeset{valid?: true} = changeset ->
           repo.insert(changeset)

         changeset ->
           {:error, changeset}
       end
  end

  @doc """
  Updates an existing academic paper, Used for admin functionality. To make sure that data is not changed with a delete
  use the delete/0 function for deletes.
  """
  @spec update(academic_paper :: AcademicPaper.t(), params :: map(), repo :: Ecto.Repo.t()) ::
  {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def update(academic_paper, params, repo \\ Repo)
  def update(_, %{deleted_at: _}, _), do: {:error, {:invalid_operation, "use delete/1 for the delete operation"}}
  def update(_, %{"deleted_at" => _}, _), do: {:error, {:invalid_operation, "use delete/1 for the delete operation"}}
  def update(%AcademicPaper{} = original, params, repo) when is_map(params) do
    original
    |> AcademicPaper.changeset(params)
    |> case do
         %Ecto.Changeset{valid?: true} = changeset ->
           repo.update(changeset)

         changeset ->
           {:error, changeset}
       end
  end

  @doc """
  Deletes an academic paper. This is a logical delete
  """
  @spec delete(academic_paper :: AcademicPaper.t(), repo :: Ecto.Repo.t()) ::
  {:ok, AcademicPaper.t()} | {:error, :no_record_found}
  def delete(%AcademicPaper{id: id}, repo \\ Repo) do
    id
    |> get(repo)
    |> case do
         %AcademicPaper{} = academic_paper ->
           academic_paper
           |> AcademicPaper.changeset(%{deleted_at: DateTime.utc_now()})
           |> repo.update()

         nil ->
           {:error, :no_record_found}
       end
  end
end
