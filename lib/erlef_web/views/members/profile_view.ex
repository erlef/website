defmodule ErlefWeb.Members.ProfileView do
  use ErlefWeb, :view

  alias Erlef.Accounts.Member

  def is_paying?(member), do: Member.is_paying?(member)

  def member_since(member) do
    Calendar.strftime(member.since, "%B, %d, %Y")
  end

  def member_level(member) do
    Member.membership_level(member, humanize: true)
  end
end
