defmodule ErlefWeb.Members.ProfileViewTest do
  use ErlefWeb.ConnCase, async: true

  alias ErlefWeb.Members.ProfileView
  alias Erlef.Accounts.Member

  test "member_since/1" do
    member = %Member{member_since: ~D[2019-05-30]}
    assert "May, 30, 2019" == ProfileView.member_since(member)
  end

  test "member_level/1" do
    member = %Member{membership_level: :basic}
    assert "Basic Membership" == ProfileView.member_level(member)
  end
end
