defmodule Erlef.Community do
  alias Erlef.Community.Languages

  def all() do
    %{
      languages: Languages.all()
    }
  end
end
