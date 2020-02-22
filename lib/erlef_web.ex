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
      alias ErlefWeb.Router.Helpers, as: Routes

      defp recaptcha_site_key, do: System.get_env("RECAPTCHA_SITE_KEY")
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
      alias ErlefWeb.Router.Helpers, as: Routes

      def render_shared(template, assigns \\ []) do
        render(ErlefWeb.SharedView, template, assigns)
      end

      def logged_in?(assigns) do
        !!assigns[:current_user]
      end

      def is_admin?(assigns) do
        user = assigns[:current_user]
        user.is_admin || false
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
