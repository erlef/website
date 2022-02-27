defmodule ErlefWeb.Admin.DashboardView do
  use ErlefWeb, :view

  def title(_), do: "Dashboard"

  def small_info_box(title, about, icon, link, box_type \\ "info") do
    assigns = %{box_type: "small-box bg-" <> box_type, link: link, icon: "fas " <> icon, about: about, title: title}

    ~H"""
    <div class="col-lg-3 col-6">
      <!-- small card -->
      <div class={@box_type}>
        <div class="inner">
          <h3><%= @title %></h3>

          <p><%= @about %></p>
        </div>
        <div class="icon">
          <i class={@icon}></i>
        </div>
        <a href={@link} class="small-box-footer">
          More info <i class="fas fa-arrow-circle-right"></i>
        </a>
      </div>
      </div>
    """
  end
end
