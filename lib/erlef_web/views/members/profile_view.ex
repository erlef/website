defmodule ErlefWeb.Members.ProfileView do
  use ErlefWeb, :view

  alias Erlef.Accounts.Member
  alias Erlef.Jobs

  def is_paying?(member), do: Member.is_paying?(member)

  def member_since(member) do
    Calendar.strftime(member.member_since, "%B, %d, %Y")
  end

  def member_level(member) do
    Member.membership_level(member, humanize: true)
  end

  def can_post?(assigns) do
    Jobs.can_create_post?(assigns.current_user)
  end
end
