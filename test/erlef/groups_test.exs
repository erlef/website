defmodule Erlef.GroupsTest do
  use Erlef.DataCase

  alias Erlef.Groups
  alias Erlef.Groups.{Volunteer, WorkingGroup, WorkingGroupChair, WorkingGroupVolunteer}

  setup do
    v = insert(:volunteer)
    chair = insert(:volunteer)
    wg = insert(:working_group)

    c = %{
      volunteer_id: chair.id,
      working_group_id: wg.id
    }

    {:ok, %WorkingGroupChair{}} = Groups.create_working_group_chair(c)

    p = %{
      volunteer_id: v.id,
      working_group_id: wg.id
    }

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_working_group_volunteer(p)

    {:ok, wg} = Erlef.Groups.get_working_group_by_slug(wg.slug)

    [
      chair: Repo.preload(chair, :working_groups),
      volunteer: Repo.preload(v, :working_groups),
      working_group: Repo.preload(wg, :volunteers)
    ]
  end

  test "is_chair?/2", %{volunteer: v, chair: chair, working_group: wg} do
    assert Groups.is_chair?(wg, %Erlef.Accounts.Member{id: chair.member_id})
    assert Groups.is_chair?(wg, chair)
    refute Groups.is_chair?(wg, v)
    refute Groups.is_chair?(wg, Ecto.UUID.generate())
  end

  test "list_volunteers/0" do
    assert [%Volunteer{} | _] = Groups.list_volunteers()
  end

  test "change_volunteer/2", %{chair: chair} do
    assert %Ecto.Changeset{} = Erlef.Groups.change_volunteer(chair, %{name: "eh?"})
  end

  describe "create_volunteer/1" do
    test "when attrs are valid" do
      assert {:ok, %Volunteer{}} = Groups.create_volunteer(%{name: "??eh?", avatar_url: "??eh?"})
      uuid = Ecto.UUID.generate()

      assert {:ok, %Volunteer{member_id: ^uuid}} =
               Groups.create_volunteer(%{member_id: uuid, name: "?eh?", avatar_url: "?eh?"})
    end

    test "when attrs are invalid" do
      assert {:error, cs} = Groups.create_volunteer(%{name: nil, avatar_url: 123})

      assert cs.errors == [
               name: {"can't be blank", [validation: :required]},
               avatar_url: {"is invalid", [type: :string, validation: :cast]}
             ]

      assert(
        {:error, cs} =
          Groups.create_volunteer(%{member_id: 123, name: "?eh?", avatar_url: "?eh?"})
      )

      assert cs.errors == [{:member_id, {"is invalid", [type: Ecto.UUID, validation: :cast]}}]
    end
  end

  describe "update_volunteer/1" do
    test "when attrrs are valid", %{volunteer: v} do
      assert {:ok, %Volunteer{name: "Eh?"}} = Groups.update_volunteer(v, %{name: "Eh?"})
    end

    test "when attrs are invalid", %{volunteer: v} do
      assert {:error, cs} = Groups.update_volunteer(v, %{name: nil})
      assert cs.errors == [name: {"can't be blank", [validation: :required]}]
    end
  end

  describe "delete_volunteer/1" do
    test "when volunteer is valid", %{volunteer: v} do
      assert {:ok, _} = Groups.delete_volunteer(v)
      assert nil == Groups.get_volunteer(v.id)
    end

    test "when volunteer does not exist", %{volunteer: v} do
      assert_raise Ecto.StaleEntryError, fn ->
        Groups.delete_volunteer(%{v | id: Ecto.UUID.generate()})
      end
    end
  end

  @valid_wg_attrs %{
    description: "To do things",
    formed: "2019-04-30",
    proposal: "Foo",
    proposal_html: "<p>Foo</p>",
    meta: %{
      email: "local-282@erlef.org",
      gcal_url: nil,
      github: nil
    },
    name: "Local 242",
    slug: "local-242"
  }

  @invalid_wg_attrs %{
    description: nil,
    formed: "2019-04-30",
    proposal: nil,
    proposal_html: Date.utc_today(),
    meta: %{
      email: nil,
      gcal_url: nil,
      github: nil
    },
    name: 123,
    slug: nil
  }

  describe "create_working_group/1" do
    test "when attrs are valid" do
      assert {:ok, %WorkingGroup{}} = Groups.create_working_group(@valid_wg_attrs)
    end

    test "when attrs are invalid" do
      assert {:error, cs} = Groups.create_working_group(@invalid_wg_attrs)

      exp = [
        slug: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]},
        proposal: {"can't be blank", [validation: :required]},
        name: {"is invalid", [type: :string, validation: :cast]}
      ]

      assert cs.errors == exp
    end
  end

  describe "update_working_group/2" do
    test "when attrs are valid", %{working_group: wg} do
      assert {:ok, %WorkingGroup{}} = Groups.update_working_group(wg, @valid_wg_attrs)
    end

    test "when attrs are invalid", %{working_group: wg} do
      assert {:error, cs} = Groups.update_working_group(wg, @invalid_wg_attrs)

      exp = [
        slug: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]},
        proposal: {"can't be blank", [validation: :required]},
        name: {"is invalid", [type: :string, validation: :cast]}
      ]

      assert cs.errors == exp
    end
  end

  describe "delete_working_group/1" do
    test "when volunteer is valid", %{working_group: wg} do
      total_wgv_count = Repo.count(WorkingGroupVolunteer)
      assert {:ok, _} = Groups.delete_working_group(wg)
      assert nil == Groups.get_working_group(wg.id)
      assert total_wgv_count - Enum.count(wg.volunteers) == Repo.count(WorkingGroupVolunteer)
    end

    test "when volunteer does not exist", %{volunteer: v} do
      assert_raise Ecto.StaleEntryError, fn ->
        Groups.delete_volunteer(%{v | id: Ecto.UUID.generate()})
      end
    end
  end

  test "change_working_group/2", %{working_group: wg} do
    assert %Ecto.Changeset{} = Erlef.Groups.change_working_group(wg, %{name: "eh?"})
  end

  describe "create_working_group_volunteer/1" do
    test "when attrs are valid", %{working_group: wg} do
      {:ok, %Volunteer{} = v} = Groups.create_volunteer(%{name: "volunteer!", avatar_url: "hmm!"})

      p = %{
        volunteer_id: v.id,
        working_group_id: wg.id
      }

      {:ok, %WorkingGroupVolunteer{}} = Groups.create_working_group_volunteer(p)
    end

    test "when attrs are invalid", %{working_group: wg} do
      p = %{
        volunteer_id: Ecto.UUID.generate(),
        working_group_id: wg.id
      }

      {:error, cs} = Groups.create_working_group_volunteer(p)

      exp = [
        volunteer_id:
          {"does not exist",
           [constraint: :foreign, constraint_name: "working_group_volunteers_volunteer_id_fkey"]}
      ]

      assert cs.errors == exp
    end
  end

  describe "sponsors" do
    alias Erlef.Groups.Sponsor

    @valid_attrs %{
      logo_url: "some logo_url",
      is_founding_sponsor: true,
      name: "some name",
      url: "some url",
      created_by: Ecto.UUID.generate()
    }

    @update_attrs %{
      logo_url: "some updated logo_url",
      is_founding_sponsor: false,
      name: "some updated name",
      url: "some updated url",
      updated_by: Ecto.UUID.generate()
    }
    @invalid_attrs %{logo_url: nil, is_founding_sponsor: nil, name: nil, url: nil}

    def sponsor_fixture(attrs \\ %{}) do
      {:ok, sponsor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groups.create_sponsor()

      sponsor
    end

    test "list_sponsors/0 returns all sponsors" do
      sponsor = sponsor_fixture()
      assert Groups.list_sponsors() == [sponsor]
    end

    test "get_sponsor!/1 returns the sponsor with given id" do
      sponsor = sponsor_fixture()
      assert Groups.get_sponsor!(sponsor.id) == sponsor
    end

    test "create_sponsor/1 with valid data creates a sponsor" do
      assert {:ok, %Sponsor{} = sponsor} = Groups.create_sponsor(@valid_attrs)
      assert sponsor.logo_url == "some logo_url"
      assert sponsor.is_founding_sponsor == true
      assert sponsor.name == "some name"
      assert sponsor.url == "some url"
    end

    test "create_sponsor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_sponsor(@invalid_attrs)
    end

    test "update_sponsor/2 with valid data updates the sponsor" do
      sponsor = sponsor_fixture()
      assert {:ok, %Sponsor{} = sponsor} = Groups.update_sponsor(sponsor, @update_attrs)
      assert sponsor.logo_url == "some updated logo_url"
      assert sponsor.is_founding_sponsor == false
      assert sponsor.name == "some updated name"
      assert sponsor.url == "some updated url"
    end

    test "update_sponsor/2 with invalid data returns error changeset" do
      sponsor = sponsor_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_sponsor(sponsor, @invalid_attrs)
      assert sponsor == Groups.get_sponsor!(sponsor.id)
    end

    test "delete_sponsor/1 deletes the sponsor" do
      sponsor = sponsor_fixture()
      assert {:ok, %Sponsor{}} = Groups.delete_sponsor(sponsor)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_sponsor!(sponsor.id) end
    end

    test "change_sponsor/1 returns a sponsor changeset" do
      sponsor = sponsor_fixture()
      assert %Ecto.Changeset{} = Groups.change_sponsor(sponsor)
    end
  end
end
