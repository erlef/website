defmodule Erlef.AccountsTest do
  use ExUnit.Case, async: true

  alias Erlef.Accounts

  test "get_member/1" do
    {:ok, _member} = Accounts.get_member("basic_member")
  end

  test "update_member/2" do
    {:ok, %Accounts.Member{} = member} = Accounts.get_member("basic_member")

    uuid = Ecto.UUID.generate()

    {:ok, %Accounts.Member{} = member} = Accounts.update_member(member, %{id: uuid})

    assert member.id == uuid
  end
end
