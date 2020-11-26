defmodule Erlef.Factory do
  @moduledoc """
  Factory module for database test support
  """
  use ExMachina.Ecto, repo: Erlef.Repo

  alias Erlef.Publications.AcademicPaper

  def academic_papers_factory do
    %AcademicPaper{
      id: Ecto.UUID.generate(),
      title: sequence(:title, &"Cool Title #{&1}"),
      author: "#{Faker.Person.first_name()} #{Faker.Person.last_name()}",
      language: "English",
      url: sequence(:url, &"https://example.com/paper_#{&1}"),
      technologies: ["BEAM"]
    }
  end
end
