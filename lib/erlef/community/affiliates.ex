defmodule Erlef.Community.Affiliates do
  @moduledoc """
  Module for getting static affiliate data

  All data for the affiliate page of the site can be found in [priv/data/affiliate](priv/data/affiliate).

  Said data ends up compiled into this module along with a few dynamically generated helper functions.

  As an example, we have all active affiliations in `priv/data/affiliate/affiliates.exs`, this file ends up being evalulated and the base name of the file 
  without the extension (i.e., `"affiliates"`) ends up being used to create a helper function called `all_affiliates/0`.

  Like wise the atom `affiliates` is also used as a key pointing to the evalulated term as returned by the `all/0`  function. 
  """

  data =
    for d <- "priv/data/affiliate/*.exs" |> Path.wildcard() |> Enum.sort() do
      @external_resource d
      base_name = Path.basename(d) |> String.replace(".exs", "")
      name = String.to_atom(base_name)
      fn_name = String.to_atom("all_#{base_name}")
      {evaled, _} = Code.eval_file(d)
      val = Macro.escape(evaled)

      def unquote(fn_name)() do
        unquote(val)
      end

      {name, evaled}
    end

  @data Enum.reduce(data, %{}, fn {k, v}, acc -> Map.put(acc, k, v) end)

  def all() do
    @data
  end
end
