defmodule ErlefWeb.WorkingGroupView do
  use ErlefWeb, :view

  def content(slug) when slug in ["embedded", "embedded-systems"] do
    [
      {"BEAM on the Embedded Landscape 2020", "landscape"}
    ]
  end

  def content(_), do: nil
end
