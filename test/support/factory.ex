defmodule Erlef.Factory do
  @moduledoc """
  Factory module for database test support
  """

  alias Erlef.Repo
  alias Erlef.AcademicPapers.AcademicPaper
  alias Erlef.Accounts.Member
  alias Erlef.Community.Event
  alias Erlef.Groups.{WorkingGroup, WorkingGroupChair, WorkingGroupVolunteer, Volunteer, Sponsor}
  alias Erlef.News.NewsTip
  alias Erlef.Blog.Post

  def build(:post) do
    %Post{
      title: Faker.Lorem.sentence(3),
      slug: Faker.Internet.slug(),
      excerpt: Faker.Lorem.paragraph(3),
      body: Faker.Markdown.markdown(),
      authors: [Faker.Person.name()],
      category: Faker.Internet.slug(),
      tags: [Faker.Lorem.word()],
      status: Enum.random([:draft, :published, :archived]),
      published_at: DateTime.truncate(Faker.DateTime.backward(7), :second),
      owner: build(:member)
    }
  end

  def build(:news_tip) do
    %NewsTip{
      type: :announcement,
      status: :queued,
      who: Faker.Lorem.sentence(),
      what: Faker.Lorem.paragraph(),
      at_where: Faker.Lorem.sentence(),
      at_when: Faker.Lorem.sentence(),
      why: Faker.Lorem.paragraph(),
      how: Faker.Lorem.paragraph(),
      supporting_documents: [%{url: Faker.Internet.url(), mime: "image/png"}],
      additional_info: Faker.Lorem.sentence()
    }
  end

  def build(:event) do
    %Event{
      title: Faker.Lorem.sentence(),
      description: Faker.Lorem.paragraph(),
      start: Date.utc_today(),
      end: Date.utc_today(),
      organizer: Faker.Company.name(),
      url: Faker.Internet.url()
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

  def build(:member) do
    %Member{
      name: "#{Faker.Person.first_name()} #{Faker.Person.last_name()}",
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      email: Faker.Internet.email(),
      deactivated_at: nil,
      has_email_address: false,
      has_email_alias: false,
      is_app_admin: false,
      is_archived: false,
      is_donor: false,
      member_since: ~D[2019-05-30],
      membership_enabled: true,
      membership_level: :basic,
      roles: [],
      suspended_member: false,
      terms_of_use_accepted: true,
      external: %{source: :wildapricot, id: Integer.to_string(:rand.uniform(10_000))}
    }
  end

  def build(:admin) do
    build(:member, is_app_admin: true, roles: [:app_admin])
  end

  def build(:sponsor) do
    %Sponsor{
      active: true,
      logo_url: Faker.Internet.url(),
      is_founding_sponsor: false,
      name: Faker.Company.name(),
      url: Faker.Internet.url()
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

  def insert_member!(name) do
    {:ok, contact} = Erlef.Test.WildApricot.get_contact(name)
    params = Erlef.Accounts.to_member_params(contact, %{from: :wildapricot})
    insert!(:member, params)
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
