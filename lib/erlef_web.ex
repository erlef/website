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

      import Plug.Conn
      import ErlefWeb.Gettext
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
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import ErlefWeb.ErrorHelpers
      import ErlefWeb.Gettext
      import ErlefWeb.HTML
      import Phoenix.LiveView.Helpers
      import ErlefWeb.ViewHelpers

      alias ErlefWeb.Router.Helpers, as: Routes

      def render_shared(template, assigns \\ []) do
        render(ErlefWeb.SharedView, template, assigns)
      end

      def logged_in?(assigns) do
        !!assigns[:current_user]
      end

      def image_path(conn, nil), do: ""

      def image_path(_conn, <<"http", _rest::binary>> = url), do: url

      def image_path(conn, <<"volunteers", _rest::binary>> = path) do
        Routes.static_path(conn, "/images/" <> path)
      end

      def image_path(conn, path), do: Routes.static_path(conn, path)
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

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
