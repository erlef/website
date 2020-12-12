defmodule Erlef.PublicationsTest do
  @moduledoc """
  Tests for the AcademicPaper Query module
  """
  use Erlef.DataCase

  alias Erlef.Publications.Query
  alias Erlef.Publications.AcademicPaper

  describe "all/0" do
    test "returns an empty list when no academic papers are present" do
      assert [] = Query.all(Repo)
    end

    test "returns active academic papers" do
      insert_list(3, :academic_papers)
      deleted = insert(:academic_papers, %{deleted_at: DateTime.utc_now()})
      academic_papers = Query.all(Repo)

      assert 3 = Enum.count(academic_papers)
      refute Enum.any?(academic_papers, &(&1.id == deleted.id))
    end
  end

  describe "published/0" do
    test "returns an empty list when no published academic papers are present" do
      assert [] = Query.published(Repo)
    end

    test "returns active published academic papers" do
      insert_list(3, :academic_papers)
      insert_list(2, :academic_papers, %{published_at: DateTime.utc_now()})

      deleted =
        insert(:academic_papers, %{
          published_at: DateTime.utc_now(),
          deleted_at: DateTime.utc_now()
        })

      academic_papers = Query.published(Repo)

      assert 2 = Enum.count(academic_papers)
      refute Enum.any?(academic_papers, &(&1.id == deleted.id))
    end
  end

  describe "unpublished/0" do
    test "returns an empty list when no unpublished academic papers are present" do
      assert [] = Query.unpublished(Repo)
    end

    test "returns active unpublished academic papers" do
      insert_list(3, :academic_papers)
      insert_list(2, :academic_papers, %{published_at: DateTime.utc_now()})
      deleted = insert(:academic_papers, %{deleted_at: DateTime.utc_now()})

      academic_papers = Query.unpublished(Repo)

      assert 3 = Enum.count(academic_papers)
      refute Enum.any?(academic_papers, &(&1.id == deleted.id))
    end
  end

  describe "get/1" do
    test "returns nil if record is not found" do
      refute Query.get(Ecto.UUID.generate(), Repo)
    end

    test "returns active academic paper with a valid id" do
      title = "Fear & Loathing on the Campaign Trail '72"
      academic_paper = insert(:academic_papers, %{title: title})

      assert found = Query.get(academic_paper.id, Repo)
      assert title == found.title
    end

    test "returns nil for inactive academic paper with a valid id" do
      academic_paper = insert(:academic_papers, %{deleted_at: DateTime.utc_now()})

      refute Query.get(academic_paper.id, Repo)
    end
  end

  describe "create/1" do
    test "returns error if the required fields are missing" do
      assert {:error, %Ecto.Changeset{errors: errors}} = Query.create(%{})

      assert errors == [
               title: {"can't be blank", [validation: :required]},
               author: {"can't be blank", [validation: :required]},
               language: {"can't be blank", [validation: :required]},
               url: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns the created academic paper on success" do
      params = %{
        title: "Fear and Loathing on the Campaign Trail in ’72",
        author: "Hunter S. Thompson",
        language: "English",
        url:
          "https://www.rollingstone.com/culture/culture-news/fear-and-loathing-on-the-campaign-trail-in-72-204428/",
        technologies: ["BEAM"]
      }

      assert {:ok, %AcademicPaper{} = academic_paper} = Query.create(params, Repo)
      assert params.title == academic_paper.title
      assert params.author == academic_paper.author
      assert params.language == academic_paper.language
      assert params.url == academic_paper.url
      assert params.technologies == academic_paper.technologies
      refute academic_paper.pay_wall?
      refute academic_paper.published_at
      refute academic_paper.deleted_at
    end
  end

  describe "update/1" do
    setup do
      {:ok, academic_paper: insert(:academic_papers)}
    end

    test "returns error if the required fields are not set", %{academic_paper: academic_paper} do
      assert {:error, %Ecto.Changeset{errors: errors}} =
               Query.update(academic_paper, %{title: nil, author: nil, language: nil, url: nil})

      assert errors == [
               title: {"can't be blank", [validation: :required]},
               author: {"can't be blank", [validation: :required]},
               language: {"can't be blank", [validation: :required]},
               url: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns the updated academic paper on success", %{academic_paper: academic_paper} do
      params = %{
        title: "Fear and Loathing on the Campaign Trail in ’72",
        author: "Hunter S. Thompson",
        language: "Spanish",
        url:
          "https://www.rollingstone.com/culture/culture-news/fear-and-loathing-on-the-campaign-trail-in-72-204428/",
        technologies: ["Erlang", "Elixir"]
      }

      assert {:ok, %AcademicPaper{} = updated} = Query.update(academic_paper, params, Repo)
      assert updated.id == academic_paper.id
      assert params.title == updated.title
      assert params.author == updated.author
      assert params.language == updated.language
      assert params.url == updated.url
      assert params.technologies == updated.technologies
      refute updated.deleted_at
    end

    test "prevent delete in updates", %{academic_paper: academic_paper} do
      delete_error = {:invalid_operation, "use delete/1 for the delete operation"}

      assert {:error, delete_error} ==
               Query.update(academic_paper, %{deleted_at: DateTime.utc_now()})

      assert {:error, delete_error} ==
               Query.update(academic_paper, %{"deleted_at" => DateTime.utc_now()})
    end
  end

  describe "delete/1" do
    setup do
      {:ok, academic_paper: insert(:academic_papers)}
    end

    test "returns the deleted academic paper on success", %{academic_paper: academic_paper} do
      assert [active] = Query.all(Repo)
      assert active.id == academic_paper.id

      assert {:ok, %AcademicPaper{} = deleted} = Query.delete(academic_paper, Repo)
      assert deleted.id == academic_paper.id
      assert deleted.deleted_at

      assert [] == Query.all(Repo)
    end

    test "returns an error if the record is not found" do
      assert {:error, :no_record_found} =
               Query.delete(%AcademicPaper{id: Ecto.UUID.generate()}, Repo)
    end
  end
end
