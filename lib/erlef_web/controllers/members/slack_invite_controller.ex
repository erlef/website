defmodule ErlefWeb.Members.SlackInviteController do
  use ErlefWeb, :controller

  alias Erlef.Accounts
  alias Erlef.Accounts.Member
  alias Erlef.Admins

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, _) do
    member = conn.assigns.current_user
    process(conn, member)
  end

  defp process(conn, %Member{has_requested_slack_invite: false} = member) do
    with {:ok, member} <- set_slack_invite_requested(member),
         {:ok, _} <- Admins.notify(:new_slack_invite, %{member: member}) do
      conn
      |> put_flash(:info, success_msg())
      |> redirect(to: Routes.members_profile_path(conn, :show))
    else
      _ ->
        conn
        |> put_flash(:error, "An unknown error occured.")
        |> redirect(to: Routes.members_profile_path(conn, :show))
    end
  end

  defp process(conn, _member) do
    conn
    |> put_flash(:error, "You have already requested an invite to Erlef slack.")
    |> redirect(to: Routes.members_profile_path(conn, :show))
  end

  defp success_msg do
    """
    Your Slack invitation request was successfully created. 
    Note: there are humans behind this process and as such it can take up 
    to 24 hours to process it. 
    """
  end

  defp set_slack_invite_requested(member) do
    attrs = %{has_requested_slack_invite: true, requested_slack_invite_at: DateTime.utc_now()}
    Accounts.update_member(member, attrs)
  end
end
