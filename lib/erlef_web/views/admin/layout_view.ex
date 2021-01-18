defmodule ErlefWeb.Admin.LayoutView do
  use ErlefWeb, :view

  def nav_link(params) do
    p =
      [
        {:class, "nav-link"},
        {"data-toggle", "tooltip"},
        {"data-placement", "right"},
        {:title, Keyword.get(params, :name, "")}
      ] ++ params

    ~E"""
      <li class="nav-item"> 
        <%= link(p) do %>
          <i class="fas <%= Keyword.get(params, :icon, "") %>"></i>
          <p><%= Keyword.get(params, :name) %></p>
        <% end %>
      </li>
    """
  end
end
