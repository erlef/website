defmodule Erlef.MembersTest do
  use Erlef.DataCase

  alias Erlef.Accounts
  alias Erlef.Members
  alias Erlef.Members.EmailRequest
  import Swoosh.TestAssertions

  setup do
    member = insert_member!("annual_member")
    admin = insert_member!("admin")
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
               submitted_by_id: member.id
             })

    assert %EmailRequest{id: id} = Members.get_email_request(req.id)
    assert %EmailRequest{id: ^id} = Members.get_email_request_by_member(member)
    assert_email_sent(Erlef.Admins.Notifications.new(:new_email_request, %{}))
  end

  test "outstanding_email_requests/0", %{member: member} do
    assert {:ok, %EmailRequest{} = _req} =
             Members.create_email_request(%{
               status: :created,
               type: :email_alias,
               username: "starbelly",
               submitted_by_id: member.id
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
               submitted_by_id: member.id
             })

    assert Members.update_email_request(req, %{status: :in_progress})

    assert Members.update_email_request(req.id, %{status: :created})
  end

  describe "complete_email_request/1" do
    test "when request is of type email_alias", %{admin: admin, member: member} do
      assert {:ok, %EmailRequest{} = req} =
               Members.create_email_request(%{
                 status: :created,
                 type: :email_alias,
                 username: "starbelly",
                 assigned_to_id: admin.id,
                 submitted_by_id: member.id
               })

      assert Members.complete_email_request(%{id: req.id})
      assert_email_sent(Members.EmailRequestNotification.email_alias_created(member))
    end

    test "when request is of type email_box", %{admin: admin, member: member} do
      assert {:ok, %EmailRequest{} = req} =
               Members.create_email_request(%{
                 status: :created,
                 type: :email_box,
                 username: "starbelly",
                 assigned_to_id: admin.id,
                 submitted_by_id: member.id
               })

      member = Accounts.get_member!(member.id)
      member = %{member | erlef_email_address: "starbelly@erlef.org"}
      assert Members.complete_email_request(%{id: req.id, password: "hunter42"})
      assert_email_sent(Members.EmailRequestNotification.email_box_created(member, "hunter42"))
    end
  end
end
