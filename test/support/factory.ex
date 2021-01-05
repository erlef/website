defmodule Erlef.Factory do
  @moduledoc """
  Factory module for database test support
  """
  use ExMachina.Ecto, repo: Erlef.Repo

  alias Erlef.Publications.AcademicPaper
  alias Erlef.Community.Event
  alias Erlef.Groups.{WorkingGroup, WorkingGroupChair, WorkingGroupVolunteer, Volunteer}

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

  def volunteer_factory do
    %Volunteer{
      member_id: Ecto.UUID.generate(),
      name: Faker.Person.name(),
      avatar_url: Faker.Avatar.image_url()
    }
  end

  def working_group_factory do
    %WorkingGroup{
      description: "To do things",
      formed: Faker.Date.backward(365),
      proposal: Faker.Markdown.headers(),
      proposal_html: "<p>Foo</p>",
      meta: %{
        email: Faker.Internet.email(),
        gcal_url: nil,
        github: nil
      },
      name: Faker.Team.name(),
      slug: Faker.Internet.slug()
    }
  end

  def working_group_volunteer_factory do
    %WorkingGroupVolunteer{
      working_group: build(:working_group),
      volunteer: build(:volunteer)
    }
  end

  def working_group_chair_factory do
    %WorkingGroupChair{
      working_group: build(:working_group),
      volunteer: build(:volunteer)
    }
  end
end
