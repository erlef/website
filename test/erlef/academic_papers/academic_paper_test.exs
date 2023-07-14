defmodule Erlef.AcademicPapers.AcademicPaperTest do
  use ExUnit.Case

  alias Erlef.AcademicPapers.AcademicPaper

  @test_data %{
    title: "Fear and Loathing on the Campaign Trail in ’72",
    author: "Hunter S. Thompson",
    language: "English",
    url:
      "https://www.rollingstone.com/culture/culture-news/fear-and-loathing-on-the-campaign-trail-in-72-204428/",
    technologies: ["BEAM"]
  }

  describe "validate required fields" do
    test "errors on missing required fields" do
      assert %{valid?: false, errors: errors} = AcademicPaper.changeset(%AcademicPaper{}, %{})

      assert errors == [
               title: {"can't be blank", [validation: :required]},
               author: {"can't be blank", [validation: :required]},
               language: {"can't be blank", [validation: :required]},
               url: {"can't be blank", [validation: :required]},
               technologies: {"can't be blank", [validation: :required]}
             ]
    end

    test "valid changeset with required fields present" do
      assert %{valid?: true, errors: []} = AcademicPaper.changeset(%AcademicPaper{}, @test_data)
    end
  end
end
