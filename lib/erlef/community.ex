defmodule Erlef.Community do
  @moduledoc """
  Context module for erlef community data.
  """

  alias Erlef.Community.Languages

  def all() do
    %{
      languages: Languages.all()
    }
  end
end
