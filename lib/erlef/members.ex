defmodule Erlef.Members do
  Enum.each(Application.get_env(:erlef, :rosters), fn roster ->
    Module.register_attribute(__MODULE__, roster, persist: true)
    Module.put_attribute(__MODULE__, roster, Application.get_env(:erlef, roster))

    def roster(unquote(Atom.to_string(roster))) do
      Keyword.get(__MODULE__.__info__(:attributes), unquote(roster))
    end
  end)
end
