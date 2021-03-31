defmodule ErlefWeb.PageView do
  use ErlefWeb, :view

  import ErlefWeb.ViewHelpers

  def community_card_wall(items) do
    ~E"""
     <div class="row">
        <%= for i <- items do %>
          <div class="col-md-4 mb-5">
            <div class="card community-card h-100 shadow-sm">
              <div class="card-header d-flex align-items-center"> 
                <%= if i.icon do %>
                  <img class="community-icon" src="<%= i.icon %>" />
                  <span class="community-name"><%= i.name %></span>
                <% end %>

                <%= if i.logo do %>
                  <img style="height:32px;" src="<%= i.logo %>" class="svg">
                <% end %>

                <%= if is_nil(i.icon) and is_nil(i.logo)  do %>
                  <span class="community-name"><%= i.name %></span>
                <% end %>

              </div>

              <div class="card-body">
                <p><%= i.about %></p>

                <span class="center-text" style="position: absolute; bottom: 0.5rem;">
                  <a class="align-text-bottom" href="<%= i.link %>" target="_blank">Learn more</a>
                </span>
              </div>
            </div>
          </div>
        <% end %>
    </div>
    """
  end

  def fellows_card_wall(items) do
    ~E"""
     <div class="row">
    <%= for i <- items do %>

      <div class="ml-1 mr-1">
      <h2 style="text-decoration:underline;"><%= i.name %></h2>
      <div class="col-sm-14 mb-4">
        <div class="card" style="">
          <div class="row no-gutters">
            <div class="col-sm-5" style="">
                <img class="card-img" src="<%= i.avatar %>" alt="<%= i.name %>">
            </div>
      
            <div class="col-sm-7">
              <div class="card-body">
                <p class="card-text"><%= i.about %></p>
              </div>
            </div>
          </div>
        </div>
      </div>
      </div>
      <% end %>
    </div>
    """
  end
end
