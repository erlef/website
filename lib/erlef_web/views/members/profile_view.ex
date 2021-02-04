defmodule ErlefWeb.Members.ProfileView do
  use ErlefWeb, :view

  alias Erlef.Accounts.Member

  def is_paying?(member), do: Member.is_paying?(member)

  def member_since(member) do
    {:ok, dt, _offset} = DateTime.from_iso8601(member.member_since)
    Calendar.strftime(dt, "%B, %d, %Y")
  end

  def member_level(member) do
    Member.membership_level(member, humanize: true)
  end
end
