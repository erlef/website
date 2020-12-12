defmodule Erlef.Community.Resources do
  @moduledoc """
  Module for getting static community data

  All resources data for the community page of the site can be found in 
  [priv/data/community](priv/data/community). 
  Said data ends up compiled into this module along with a few dynamically generated helper functions.
  As an example,we have all active languages in 
  `priv/data/community/languages.exs`, 
  this file ends up being evalulated and the base name of the file without the 
  extension (i.e., `"languages"`) ends up being used to create a helper function called `all_languages/0`. 
  Like wise the atom `languages` is also used as a key pointing to the evalulated term as returned by the `all/0`  function. 
  """

  data =
    for d <- "priv/data/community/*.exs" |> Path.wildcard() |> Enum.sort() do
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
