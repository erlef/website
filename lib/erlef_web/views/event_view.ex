defmodule ErlefWeb.EventView do
  use ErlefWeb, :view

  import ErlefWeb.ViewHelpers

  @spec active_class(String.t(), String.t()) :: String.t()
  def active_class(selected, link_type) when selected == link_type, do: "active"
  def active_class(_selected, _link_type), do: ""
end
