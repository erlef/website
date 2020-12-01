defmodule ErlefWeb.Members.ProfileView do
  use ErlefWeb, :view

  def member_since(member) do
    {:ok, dt, _offset} = DateTime.from_iso8601(member.member_since)
    Calendar.strftime(dt, "%B, %d, %Y")
  end

  def member_level(member) do
    %{"Name" => level} = member.membership_level
    level
  end
end
