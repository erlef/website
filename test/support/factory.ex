defmodule Erlef.Factory do
  @moduledoc """
  Factory module for database test support
  """

  alias Erlef.Repo
  alias Erlef.Publications.AcademicPaper
  alias Erlef.Community.Event
  alias Erlef.Groups.{WorkingGroup, WorkingGroupChair, WorkingGroupVolunteer, Volunteer}

  def build(:event) do
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

  def build(:academic_paper) do
    %AcademicPaper{
      id: Ecto.UUID.generate(),
      title: Faker.Lorem.sentence(),
      author: "#{Faker.Person.first_name()} #{Faker.Person.last_name()}",
      language: "English",
      url: Faker.Internet.url(),
      technologies: ["BEAM"]
    }
  end

  def build(:volunteer) do
    %Volunteer{
      member_id: Ecto.UUID.generate(),
      name: Faker.Person.name(),
      avatar_url: Faker.Avatar.image_url()
    }
  end

  def build(:working_group) do
    %WorkingGroup{
      description: "To do things",
      formed: Faker.Date.backward(365),
      charter: Faker.Markdown.headers(),
      charter_html: "<p>Foo</p>",
      meta: %{
        email: Faker.Internet.email(),
        gcal_url: nil,
        github: nil
      },
      name: Faker.Team.name(),
      slug: Faker.Internet.slug()
    }
  end

  def build(:working_group_volunteer) do
    %WorkingGroupVolunteer{
      working_group: build(:working_group),
      volunteer: build(:volunteer)
    }
  end

  def build(:working_group_chair) do
    %WorkingGroupChair{
      working_group: build(:working_group),
      volunteer: build(:volunteer)
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def datetime_utc_now() do
    DateTime.truncate(DateTime.utc_now(), :second)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  def insert_list!(n, factory_name, attributes \\ []) do
    for _i <- 1..n do
      insert!(factory_name, attributes)
    end
  end

  def params_for(factory_name, attributes \\ []) do
    factory_name
    |> build(attributes)
    |> Map.from_struct()
    |> Map.delete(:__meta__)
  end

  def string_params_for(factory_name, attributes \\ []) do
    factory_name
    |> params_for(attributes)
    |> to_string_keyed_map()
  end

  defp to_string_keyed_map(atom_map) do
    Enum.reduce(atom_map, %{}, fn {k, v}, acc ->
      Map.put(acc, Atom.to_string(k), v)
    end)
  end
end
