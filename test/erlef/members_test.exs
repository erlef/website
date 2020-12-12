defmodule Erlef.MembersTest do
  use Erlef.DataCase

  alias Erlef.Members
  alias Erlef.Members.EmailRequest
  import Swoosh.TestAssertions

  setup_all do
    {:ok, member} = Erlef.Accounts.get_member("annual_member")
    {:ok, admin} = Erlef.Accounts.get_member("admin")
    [member: member, admin: admin]
  end

  test "new_email_request/0" do
    assert %Ecto.Changeset{} = Members.new_email_request()
  end

  test "new_email_request/1" do
    assert %Ecto.Changeset{} = Members.new_email_request(%{})
  end

  test "create_new_email_request/1", %{member: member} do
    assert {:ok, %EmailRequest{} = req} =
             Members.create_email_request(%{
               status: :created,
               type: :email_alias,
               username: "starbelly",
               submitted_by: member.id
             })

    assert ^req = Members.get_email_request(req.id)
    assert ^req = Members.get_email_request_by_member(member)
    assert_email_sent(Erlef.Admins.Notifications.new(:new_email_request, %{}))
  end

  test "outstanding_email_requests/0", %{member: member} do
    assert {:ok, %EmailRequest{} = _req} =
             Members.create_email_request(%{
               status: :created,
               type: :email_alias,
               username: "starbelly",
               submitted_by: member.id
             })

    assert Members.has_email_request?(member)

    assert Members.outstanding_email_requests_count() == 1

    assert Members.outstanding_email_requests_count() ==
             Enum.count(Members.outstanding_email_requests())
  end

  test "update_email_request/2", %{member: member} do
    assert {:ok, %EmailRequest{} = req} =
             Members.create_email_request(%{
               status: :created,
               type: :email_alias,
               username: "starbelly",
               submitted_by: member.id
             })

    assert Members.update_email_request(req, %{status: :in_progress})

    assert Members.update_email_request(req.id, %{status: :created})
  end

  describe "complete_email_request/1" do
    test "when request is of type email_alias", %{member: member} do
      assert {:ok, %EmailRequest{} = req} =
               Members.create_email_request(%{
                 status: :created,
                 type: :email_alias,
                 username: "starbelly",
                 assigned_to: Ecto.UUID.generate(),
                 submitted_by: member.id
               })

      assert Members.complete_email_request(%{id: req.id})
      assert_email_sent(Members.EmailRequestNotification.email_alias_created(member))
    end

    test "when request is of type email_box", %{member: member} do
      assert {:ok, %EmailRequest{} = req} =
               Members.create_email_request(%{
                 status: :created,
                 type: :email_box,
                 username: "starbelly",
                 assigned_to: Ecto.UUID.generate(),
                 submitted_by: member.id
               })

      assert Members.complete_email_request(%{id: req.id, password: "hunter42"})
      {:ok, member} = Erlef.Accounts.get_member("annual_member")
      assert_email_sent(Members.EmailRequestNotification.email_box_created(member, "hunter42"))
    end
  end
end
