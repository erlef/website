defmodule Erlef.Factory do
  @moduledoc """
  Factory module for database test support
  """
  use ExMachina.Ecto, repo: Erlef.Repo

  alias Erlef.Publications.AcademicPaper
  alias Erlef.Community.Event
  alias Erlef.Community.EventType

  def event_type_factory do
    %EventType{
      name: Faker.Lorem.word()
    }
  end

  def event_factory do
    %Event{
      title: Faker.Lorem.sentence(),
      description: Faker.Lorem.paragraph(),
      start: Date.utc_today(),
      end: Date.utc_today(),
      organizer: Faker.Company.name(),
      url: Faker.Internet.url(),
      submitted_by: Ecto.UUID.generate()
    }
  end

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
