defmodule ErlefWeb.LayoutView do
  use ErlefWeb, :view

  def render_layout(layout, assigns, do: content) do
    render(layout, Map.put(assigns, :inner_layout, content))
  end

  def news_category_name("eef"), do: "Announcments"
  def news_category_name(name), do: humanize(name)
end
