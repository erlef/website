defmodule ErlefWeb.Admin.AcademicPaperView do
  use ErlefWeb, :view

  def title(_), do: "Academic papers"

  def get_member(nil), do: nil

  def get_member(member_id), do: Erlef.Accounts.get_member(member_id)

  def name(nil), do: "System"

  def name(member), do: member.name

  def email(nil), do: ""

  def email(member), do: member.email
end
