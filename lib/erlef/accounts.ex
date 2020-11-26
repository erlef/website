defmodule Erlef.Accounts do
  @moduledoc """
  Erlef.Accounts context module

  ## Types of accounts

  - Member

  ### Membership levels

   - basic
   - annual supporting members
   - lifetime
   - fellow
   - board
  """
  def get_member(uid) do
    {:ok, %{"access_token" => token}} = Erlef.WildApricot.get_api_token()
    {:ok, contact} = Erlef.WildApricot.get_contact(token, uid)
    {:ok, Erlef.Accounts.Member.from_contact(contact)}
  end
end
