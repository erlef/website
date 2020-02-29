defmodule Erlef.Factory do
  @moduledoc """
  Factory module for database test support
  """
  use ExMachina.Ecto, repo: Erlef.Data.Repo

  alias Erlef.Data.Schema.AcademicPaper

  def academic_papers_factory do
    %AcademicPaper{
      id: UUID.uuid4(),
      title: sequence(:title, &"Cool Title #{&1}"),
      author: "#{Faker.Name.first_name} #{Faker.Name.last_name}",
      language: "English",
      url: sequence(:url, &"https://example.com/paper_#{&1}"),
      technologies: ["BEAM"]
    }
  end
end
