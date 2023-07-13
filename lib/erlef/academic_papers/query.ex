defmodule Erlef.AcademicPapers.Query do
  @moduledoc """
  Module for the academic paper queries
  """

  import Ecto.Query, only: [from: 2]

  alias Erlef.AcademicPapers.AcademicPaper
  alias Erlef.Repo

  @doc """
  Returns all active academic papers. Used for admin functionality
  """
  @spec all(repo :: Ecto.Repo.t()) :: [AcademicPaper.t()]
  def all(repo \\ Repo) do
    from(p in AcademicPaper,
      where: is_nil(p.deleted_at),
      order_by: [p.original_publish_date, p.title]
    )
    |> repo.all()
  end

  @doc """
  Returns an academic paper by id. Used for admin functionality
  """
  @spec get(id :: binary(), repo :: Ecto.Repo.t()) :: AcademicPaper.t() | nil
  def get(id, repo \\ Repo) do
    from(p in AcademicPaper,
      where: is_nil(p.deleted_at),
      where: p.id == ^id
    )
    |> repo.one
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
    )
    |> repo.all()
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
    )
    |> repo.all()
  end

  @doc """
  Creates a new academic paper. Used for admin functionality
  """
  @spec create(changeset :: Ecto.Changeset.t() , repo :: Ecto.Repo.t()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def create(%Ecto.Changeset{} = changeset, repo \\ Repo), do: repo.insert(changeset)    

  @doc """
  Updates an existing academic paper, Used for admin functionality. To make sure that data is not changed with a delete
  use the delete/0 function for deletes.
  """
  @spec update(changeset :: Ecto.Changeset.t(), repo :: Ecto.Repo.t()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}

  def update(%Ecto.Changeset{} = changeset , repo \\ Repo), do: repo.update(changeset)
 
end
