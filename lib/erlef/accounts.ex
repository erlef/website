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

  defdelegate get_member(id), to: Erlef.Accounts.Member, as: :get
  defdelegate update_member(member, params), to: Erlef.Accounts.Member, as: :update
  defdelegate build_member(data), to: Erlef.Accounts.Member, as: :build
end
