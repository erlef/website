defmodule ErlefWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ErlefWeb, :controller
      use ErlefWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ErlefWeb
      use Gettext, backend: ErlefWeb.Gettext

      import Plug.Conn
      import Phoenix.LiveView.Controller

      alias ErlefWeb.Router.Helpers, as: Routes

      def audit(conn) do
        %{member_id: conn.assigns.current_user.id}
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/erlef_web/templates",
        namespace: ErlefWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [view_module: 1]

      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
          unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      import Phoenix.HTML
      import Phoenix.HTML.Form
      import Phoenix.Component
      use PhoenixHTMLHelpers

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      use Gettext, backend: ErlefWeb.Gettext

      import ErlefWeb.ErrorHelpers
      import ErlefWeb.HTML
      import ErlefWeb.ViewHelpers

      alias ErlefWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
