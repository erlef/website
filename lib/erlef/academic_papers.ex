defmodule Erlef.AcademicPapers do
  @moduledoc """
  Context responsible for managing Academic Papers
  """

  alias Erlef.AcademicPapers.Query
  alias Erlef.AcademicPapers.AcademicPaper
  alias Ecto.Changeset

  @spec all() :: [AcademicPaper.t()]
  def all(), do: Query.published()

  @spec get(Ecto.UUID.t()) :: AcademicPaper.t()
  def get(id), do: Query.get(id)

  @spec create_academic_paper(params :: map()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def create_academic_paper(params) do
    {date_error, new_params} = normalize_params(params)

    %AcademicPaper{}
    |> change_academic_paper(new_params)
    |> maybe_add_date_error(date_error)
    |> Query.create()
  end

  @spec update_academic_paper(academic_paper :: AcademicPaper.t(), params :: map()) ::
          {:ok, AcademicPaper.t()} | {:error, Ecto.Changeset.t()}
  def update_academic_paper(%AcademicPaper{} = academic_paper, params) do
    {date_error, new_params} = normalize_params(params)

    academic_paper
    |> change_academic_paper(new_params)
    |> maybe_add_date_error(date_error)
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
    {date_error, params0} = normalize_params(params)
    new_params = Map.put(params0, "published_at", DateTime.utc_now())

    unapproved_academic_paper
    |> change_academic_paper(new_params)
    |> maybe_add_date_error(date_error)
    |> Query.update()
  end

  # Private Internal Functions

  defp normalize_params(params) do
    params0 =
      case Map.fetch(params, "technologies") do
        {:ok, _val} ->
          params

        :error ->
          Map.put(params, "technologies", "")
      end

    params0
    |> is_valid_date
    |> case do
      false ->
        {true, params0}

      {true, new_params} ->
        {false, new_params}
    end
  end

  defp is_valid_date(params) do
    date = get_date(params)

    date
    |> no_date
    |> case do
      true ->
        {true, params}

      _ ->
        date
        |> incomplete_date
        |> case do
          true ->
            false

          _ ->
            date
            |> create_date
            |> case do
              {:error, _} ->
                false

              {:ok, valid_date} ->
                {true, Map.put(params, "original_publish_date", valid_date)}
            end
        end
    end
  end

  defp maybe_add_date_error(changeset, true),
    do: Changeset.add_error(changeset, :original_publish_date, "Invalid Date")

  defp maybe_add_date_error(changeset, _), do: changeset

  defp get_date(params) do
    [
      normalize_date(params["original_publish_date_year"]),
      normalize_date(params["original_publish_date_month"]),
      normalize_date(params["original_publish_date_day"])
    ]
  end

  defp normalize_date(field) do
    field
    |> case do
      "" ->
        nil

      val ->
        String.to_integer(val)
    end
  end

  defp no_date(date), do: date == [nil, nil, nil] || nil

  defp incomplete_date(date), do: Enum.member?(date, nil) || nil

  defp create_date(date) do
    [year, month, day] = date
    Date.new(year, month, day)
  end
end
