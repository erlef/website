defmodule Erlef.SessionTest do
  use Erlef.DataCase

  # See test/support/models/wild_apricot.ex for service detail

  alias Erlef.Accounts.Member

  test "encode/1" do
    session =
      basic_session(%Member{id: Ecto.UUID.generate(), external: %{id: 1, source: :wildapricot}})

    expected = Jason.encode!(%{"member_session" => session})
    assert {:ok, ^expected} = Erlef.Session.encode(%{"member_session" => session})
  end

  test "build/1" do
    member = insert_member!("basic_member")

    session =
      basic_session(member)
      |> Map.from_struct()
      |> Map.new(fn {k, v} -> {Atom.to_string(k), v} end)

    assert normalized = %Erlef.Session{} = Erlef.Session.build(session)
    assert normalized.member
    assert normalized.access_token == "basic_member"
  end

  describe "login/1" do
    test "creates a member record when one does not exist" do
      assert {:ok, %Erlef.Session{}} = Erlef.Session.login("basic_member")
      assert Enum.count(Repo.all(Erlef.Accounts.Member)) == 1
      assert {:ok, %Erlef.Session{}} = Erlef.Session.login("basic_member")
      assert Enum.count(Repo.all(Erlef.Accounts.Member)) == 1
    end

    test "does not create a member record when one exist" do
      insert_member!("basic_member")
      assert Enum.count(Repo.all(Erlef.Accounts.Member)) == 1
      assert {:ok, %Erlef.Session{}} = Erlef.Session.login("basic_member")
      assert Enum.count(Repo.all(Erlef.Accounts.Member)) == 1
    end

    test "updates a member record when contact changes are found" do
      member = insert_member!("basic_member")
      refute member.erlef_email_address
      uid = member.external.id

      p = %{
        "Id" => uid,
        "FieldValues" => [%{"FieldName" => "erlef_email_address", "Value" => "foo@bar.org"}]
      }

      {:ok, _} = Erlef.WildApricot.update_contact(uid, p)
      assert {:ok, %Erlef.Session{}} = Erlef.Session.login("basic_member")
      member = Erlef.Accounts.get_member!(member.id)
      assert member.erlef_email_address == "foo@bar.org"
    end
  end

  test "logout/1" do
    assert {:ok, session} = Erlef.Session.login("basic_member")
    assert :ok = Erlef.Session.logout(session)
  end

  test "should_refresh/1" do
    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: "account_id",
      member_id: "basic_member",
      expires_at: "2020-02-23 18:51:18.548936Z",
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "eh",
      erlef_app_id: Ecto.UUID.generate()
    }

    assert Erlef.Session.should_refresh?(session) == true

    member = %Member{id: Ecto.UUID.generate(), external: %{id: 1, source: :wildapricot}}
    assert Erlef.Session.should_refresh?(basic_session(member)) == false
  end

  test "expired?/1" do
    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: "account_id",
      member_id: "basic_member",
      expires_at: "2020-02-23 18:51:18.548936Z",
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "eh",
      erlef_app_id: Ecto.UUID.generate()
    }

    assert Erlef.Session.expired?(session) == true

    member = %Member{id: Ecto.UUID.generate(), external: %{id: 1, source: :wildapricot}}
    assert Erlef.Session.expired?(basic_session(member)) == false
  end

  test "refresh/1" do
    member = %Member{id: Ecto.UUID.generate(), external: %{id: 1, source: :wildapricot}}

    assert {:ok,
            %Erlef.Session{
              access_token: _,
              account_id: _,
              member_id: _,
              expires_at: _,
              refresh_token: _,
              username: "Basic Member"
            }} = Erlef.Session.refresh(basic_session(member))
  end

  defp basic_session(member) do
    %Erlef.Session{
      access_token: "basic_member",
      account_id: "account_id",
      erlef_app_id: Ecto.UUID.generate(),
      expires_at: DateTime.to_string(Timex.shift(DateTime.utc_now(), minutes: 100)),
      member_id: member.id,
      refresh_token: "rt_basic_member",
      username: "Basic Member",
      wildapricot_id: member.external.id
    }
  end
end
