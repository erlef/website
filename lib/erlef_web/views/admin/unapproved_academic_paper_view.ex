defmodule ErlefWeb.Admin.UnapprovedAcademicPaperView do
  use ErlefWeb, :view

  def title(_), do: "Unapproved Academic papers"

  def get_date(changeset), do: changeset.data.original_publish_date

  def get_member(nil), do: nil

  def get_member(member_id), do: Erlef.Accounts.get_member(member_id)

  def name(nil), do: "System"

  def name(member), do: member.name

  def email(nil), do: ""

  def email(member), do: member.email
end
