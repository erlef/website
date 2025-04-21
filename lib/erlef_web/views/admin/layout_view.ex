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

    icon = Keyword.get(params, :icon, "")
    assigns = %{icon: "fas " <> icon, params: params, p: p}

    ~H"""
      <li class="nav-item"> 
        <%= link(@p) do %>
          <i class={@icon}></i>
          <p><%= Keyword.get(@params, :name) %></p>
        <% end %>
      </li>
    """
  end

  def bread_crumbs(conn) do
    {res, _} =
      Enum.reduce(path_info(conn), {[], []}, fn seg, {acc, so_far} ->
        {[{seg, "/" <> Enum.join(Enum.reverse([seg | so_far]), "/")} | acc], [seg | so_far]}
      end)

    Enum.reverse(res)
  end

  def breadcrumb_name("admin"), do: "dashboard"
  def breadcrumb_name(name), do: name
end
