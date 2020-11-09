defmodule Erlef.SessionTest do
  use ExUnit.Case, async: true

  # See test/support/models/wild_apricot.ex for service detail

  describe "new/2" do
    test "when is admin" do
      data = %{
        "Permissions" => [
          %{
            "AccountId" => 12_345,
            "AvailableScopes" => ["contacts_me", "account_view"],
            "SecurityProfileId" => 12_345
          }
        ],
        "access_token" => "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
        "expires_in" => 1800,
        "refresh_token" => "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
        "token_type" => "Bearer"
      }

      assert %Erlef.Session{
               access_token: _,
               account_id: 12_345,
               member_id: 12_345,
               expires_at: _,
               is_admin: true,
               refresh_token: _,
               username: "starbelly"
             } = Erlef.Session.new(data)
    end

    test "when is not admin" do
      data = %{
        "Permissions" => [
          %{
            "AccountId" => 54_321,
            "AvailableScopes" => ["contacts_me", "account_view"],
            "SecurityProfileId" => 54_321
          }
        ],
        "access_token" => "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
        "expires_in" => 1_800,
        "refresh_token" => "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
        "token_type" => "Bearer"
      }

      assert %Erlef.Session{
               access_token: _,
               account_id: 54_321,
               member_id: 54_321,
               expires_at: _,
               is_admin: false,
               refresh_token: _,
               username: "eh"
             } = Erlef.Session.new(data)
    end
  end

  test "encode/1" do
    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: 54_321,
      member_id: 54_321,
      expires_at: "2020-02-23 18:51:18.548936Z",
      is_admin: false,
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "eh"
    }

    map = session |> Map.from_struct()
    expected = Jason.encode!(%{"member_session" => map})
    assert {:ok, ^expected} = Erlef.Session.encode(%{"member_session" => session})
  end

  test "normalize/1" do
    session = %{
      "access_token" => "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      "account_id" => 54_321,
      "member_id" => 54_321,
      "expires_at" => "2020-02-23 18:51:18.548936Z",
      "is_admin" => false,
      "refresh_token" => "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      "username" => "eh"
    }

    assert Erlef.Session.normalize(session) == %Erlef.Session{
             access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
             account_id: 54_321,
             member_id: 54_321,
             expires_at: "2020-02-23 18:51:18.548936Z",
             is_admin: false,
             refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
             username: "eh"
           }
  end

  test "login/1" do
    assert {:ok,
            %Erlef.Session{
              access_token: _,
              account_id: 12_345,
              member_id: 12_345,
              expires_at: _,
              is_admin: true,
              refresh_token: _,
              username: "starbelly"
            }} = Erlef.Session.login("starbelly")
  end

  test "logout/1" do
    assert {:ok, session} = Erlef.Session.login("starbelly")
    assert :ok = Erlef.Session.logout(session)
  end

  test "should_refresh/1" do
    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: 54_321,
      member_id: 54_321,
      expires_at: "2020-02-23 18:51:18.548936Z",
      is_admin: false,
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "eh"
    }

    assert Erlef.Session.should_refresh?(session) == true

    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: 54_321,
      member_id: 54_321,
      expires_at: DateTime.to_string(Timex.shift(DateTime.utc_now(), minutes: 100)),
      is_admin: false,
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "eh"
    }

    assert Erlef.Session.should_refresh?(session) == false
  end

  test "expired?/1" do
    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: 54_321,
      member_id: 54_321,
      expires_at: "2020-02-23 18:51:18.548936Z",
      is_admin: false,
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "eh"
    }

    assert Erlef.Session.expired?(session) == true

    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: 54_321,
      member_id: 54_321,
      expires_at: DateTime.to_string(Timex.shift(DateTime.utc_now(), minutes: 100)),
      is_admin: false,
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "eh"
    }

    assert Erlef.Session.expired?(session) == false
  end

  test "refresh/1" do
    session = %Erlef.Session{
      access_token: "HiuWUvqcMMuY-4AlJ5rM2ZqSbeo-",
      account_id: 12_345,
      member_id: 12_345,
      expires_at: DateTime.to_string(Timex.shift(DateTime.utc_now(), minutes: 100)),
      is_admin: false,
      refresh_token: "rt_2020-02-23_JoR0ez-SYAFjcOIkgO-5HqHWt9E-",
      username: "starbelly"
    }

    assert {:ok,
            %Erlef.Session{
              access_token: _,
              account_id: 12_345,
              member_id: 12_345,
              expires_at: _,
              is_admin: true,
              refresh_token: _,
              username: "starbelly"
            }} = Erlef.Session.refresh(session)
  end
end
