defmodule Erlef.Members.EmailRequestTest do
  use Erlef.DataCase

  alias Erlef.Members.EmailRequest

  describe "changeset/2" do
    test "when username is valid" do
      p = %{status: :created, type: :email_alias, submitted_by_id: Ecto.UUID.generate()}
      cs = EmailRequest.changeset(%EmailRequest{}, Map.put(p, :username, "foo.bar"))
      assert cs.valid?
      cs = EmailRequest.changeset(%EmailRequest{}, Map.put(p, :username, "f_o_o.b_a_r"))
      assert cs.valid?
      max_length = String.duplicate("x", 40)
      cs = EmailRequest.changeset(%EmailRequest{}, Map.put(p, :username, max_length))
      assert cs.valid?
    end

    test "when username is invalid" do
      p = %{status: :created, type: :email_alias, submitted_by_id: Ecto.UUID.generate()}
      cs = EmailRequest.changeset(%EmailRequest{}, Map.put(p, :username, "foo.bar!"))
      refute cs.valid?
      cs = EmailRequest.changeset(%EmailRequest{}, Map.put(p, :username, "f_o_o.b_a_r@"))
      refute cs.valid?
      rand = :crypto.strong_rand_bytes(4)
      cs = EmailRequest.changeset(%EmailRequest{}, Map.put(p, :username, rand))
      refute cs.valid?
      too_long = String.duplicate("x", 41)
      cs = EmailRequest.changeset(%EmailRequest{}, Map.put(p, :username, too_long))
      refute cs.valid?
    end
  end
end
