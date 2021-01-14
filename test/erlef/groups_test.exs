defmodule Erlef.GroupsTest do
  use Erlef.DataCase

  alias Erlef.Groups
  alias Erlef.Groups.{Volunteer, WorkingGroup, WorkingGroupChair, WorkingGroupVolunteer}

  @audit_opts [audit: %{member_id: Ecto.UUID.generate()}]

  setup do
    v = insert(:volunteer)
    chair = insert(:volunteer)
    wg = insert(:working_group)

    audit_params = [audit: %{member_id: chair.id}]

    {:ok, %WorkingGroupChair{}} = Groups.create_wg_chair(wg, chair, audit_params)

    {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg, v, audit_params)

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
      assert {:ok, %Volunteer{}} =
               Groups.create_volunteer(%{name: "??eh?", avatar_url: "??eh?"}, @audit_opts)

      uuid = Ecto.UUID.generate()

      assert {:ok, %Volunteer{member_id: ^uuid}} =
               Groups.create_volunteer(
                 %{member_id: uuid, name: "?eh?", avatar_url: "?eh?"},
                 @audit_opts
               )
    end

    test "when attrs are invalid" do
      assert {:error, cs} = Groups.create_volunteer(%{name: nil, avatar_url: 123}, @audit_opts)

      assert cs.errors == [
               name: {"can't be blank", [validation: :required]},
               avatar_url: {"is invalid", [type: :string, validation: :cast]}
             ]

      assert(
        {:error, cs} =
          Groups.create_volunteer(
            %{member_id: 123, name: "?eh?", avatar_url: "?eh?"},
            @audit_opts
          )
      )

      assert cs.errors == [{:member_id, {"is invalid", [type: Ecto.UUID, validation: :cast]}}]
    end
  end

  describe "update_volunteer/1" do
    test "when attrrs are valid", %{volunteer: v} do
      assert {:ok, %Volunteer{name: "Eh?"}} =
               Groups.update_volunteer(v, %{name: "Eh?"}, @audit_opts)
    end

    test "when attrs are invalid", %{volunteer: v} do
      assert {:error, cs} = Groups.update_volunteer(v, %{name: nil}, @audit_opts)
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
    charter: "Foo",
    charter_html: "<p>Foo</p>",
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
    charter: nil,
    charter_html: Date.utc_today(),
    meta: %{
      email: nil,
      gcal_url: nil,
      github: nil
    },
    name: 123,
    slug: nil
  }
  describe "create_working_group/2" do
    test "when attrs are valid" do
      assert {:ok, %WorkingGroup{}} = Groups.create_working_group(@valid_wg_attrs, @audit_opts)
    end

    test "when attrs are invalid" do
      assert {:error, cs} = Groups.create_working_group(@invalid_wg_attrs, @audit_opts)

      exp = [
        slug: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]},
        charter: {"can't be blank", [validation: :required]},
        name: {"is invalid", [type: :string, validation: :cast]}
      ]

      assert cs.errors == exp
    end
  end

  describe "update_working_group/2" do
    test "when attrs are valid", %{working_group: wg} do
      assert {:ok, %WorkingGroup{}} =
               Groups.update_working_group(wg, @valid_wg_attrs, @audit_opts)
    end

    test "when attrs are invalid", %{working_group: wg} do
      assert {:error, cs} = Groups.update_working_group(wg, @invalid_wg_attrs, @audit_opts)

      exp = [
        slug: {"can't be blank", [validation: :required]},
        description: {"can't be blank", [validation: :required]},
        charter: {"can't be blank", [validation: :required]},
        name: {"is invalid", [type: :string, validation: :cast]}
      ]

      assert cs.errors == exp
    end
  end

  test "change_working_group/2", %{working_group: wg} do
    assert %Ecto.Changeset{} = Erlef.Groups.change_working_group(wg, %{name: "eh?"})
  end

  describe "create_wg_volunteer/1" do
    test "when attrs are valid", %{working_group: wg} do
      {:ok, %Volunteer{} = v} =
        Groups.create_volunteer(%{name: "volunteer!", avatar_url: "hmm!"}, @audit_opts)

      {:ok, %WorkingGroupVolunteer{}} = Groups.create_wg_volunteer(wg, v, @audit_opts)
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
        |> Groups.create_sponsor(@audit_opts)

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
      assert {:ok, %Sponsor{} = sponsor} = Groups.create_sponsor(@valid_attrs, @audit_opts)
      assert sponsor.logo_url == "some logo_url"
      assert sponsor.is_founding_sponsor == true
      assert sponsor.name == "some name"
      assert sponsor.url == "some url"
    end

    test "create_sponsor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_sponsor(@invalid_attrs, @audit_opts)
    end

    test "update_sponsor/2 with valid data updates the sponsor" do
      sponsor = sponsor_fixture()

      assert {:ok, %Sponsor{} = sponsor} =
               Groups.update_sponsor(sponsor, @update_attrs, @audit_opts)

      assert sponsor.logo_url == "some updated logo_url"
      assert sponsor.is_founding_sponsor == false
      assert sponsor.name == "some updated name"
      assert sponsor.url == "some updated url"
    end

    test "update_sponsor/2 with invalid data returns error changeset" do
      sponsor = sponsor_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Groups.update_sponsor(sponsor, @invalid_attrs, @audit_opts)

      assert sponsor == Groups.get_sponsor!(sponsor.id)
    end

    test "change_sponsor/1 returns a sponsor changeset" do
      sponsor = sponsor_fixture()
      assert %Ecto.Changeset{} = Groups.change_sponsor(sponsor)
    end
  end

  describe "working_group_reports" do
    alias Erlef.Groups.WorkingGroupReport

    @valid_attrs %{type: :quarterly, content: "some content", is_private: true, meta: %{}}
    @update_attrs %{
      content: "some updated content",
      is_private: false,
      meta: %{}
    }
    @invalid_attrs %{content: nil, is_private: nil, meta: nil, type: nil}

    def working_group_report_fixture(attrs \\ %{}) do
      {:ok, working_group_report} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groups.create_wg_report()

      working_group_report
    end

    test "create_wg_report/1 with valid data creates a working_group_report", attrs do
      p =
        Map.merge(@valid_attrs, %{
          working_group_id: attrs.working_group.id,
          submitted_by_id: attrs.chair.id
        })

      assert {:ok, %WorkingGroupReport{} = working_group_report} = Groups.create_wg_report(p)

      assert working_group_report.content == "some content"
      assert working_group_report.is_private == true
      assert working_group_report.meta == %{}
      assert working_group_report.type == :quarterly
    end

    test "create_wg_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_wg_report(@invalid_attrs)
    end

    test "update_wg_report/2 with valid data updates the working_group_report",
         attrs do
      working_group_report =
        working_group_report_fixture(
          working_group_id: attrs.working_group.id,
          submitted_by_id: attrs.chair.id
        )

      assert {:ok, %WorkingGroupReport{} = working_group_report} =
               Groups.update_wg_report(working_group_report, @update_attrs)

      assert working_group_report.content == "some updated content"
      assert working_group_report.is_private == false
      assert working_group_report.meta == %{}
    end

    test "update_wg_report/2 with invalid data returns error changeset", attrs do
      working_group_report =
        working_group_report_fixture(
          working_group_id: attrs.working_group.id,
          submitted_by_id: attrs.chair.id
        )

      assert {:error, %Ecto.Changeset{}} =
               Groups.update_wg_report(working_group_report, @invalid_attrs)

      assert working_group_report == Groups.get_wg_report!(working_group_report.id)
    end

    test "change_wg_report/1 returns a working_group_report changeset", attrs do
      working_group_report =
        working_group_report_fixture(
          working_group_id: attrs.working_group.id,
          submitted_by_id: attrs.chair.id
        )

      assert %Ecto.Changeset{} = Groups.change_wg_report(working_group_report)
    end
  end
end
