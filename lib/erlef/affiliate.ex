defmodule Erlef.Affiliate do
  alias Erlef.Data.Resources

  defdelegate all_resources(), to: Resources, as: :all_affiliate_resources
end
