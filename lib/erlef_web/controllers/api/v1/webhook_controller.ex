defmodule ErlefWeb.API.V1.WebhookController do
  use ErlefWeb, :controller

  action_fallback ErlefWeb.FallbackController

  def handle_post(conn, params) do
    case handle(app_name(params), params) do
      :ok ->
        conn
        |> put_status(200)
        |> json(%{})

      :unauthorized ->
        conn
        |> put_status(401)
        |> json(%{error: "Unauthorized"})

      :error ->
        conn
        |> put_status(500)
        |> json(%{})
    end
  end

  defp app_name(%{"app_name" => "wildapricot"}), do: :wildapricot
  defp app_name(_), do: :unknown_app

  defp handle(:unknown_app, _), do: :unauthorized

  defp handle(:wildapricot, %{"MessageType" => "ContactModified"} = params) do
    case Erlef.WildApricot.valid_account_id?(params["AccountId"]) do
      true ->
        case params["Parameters"] do
          %{"Contact.Id" => _contact_id} ->
            :ok

          _ ->
            :error
        end

      false ->
        :unauthorized
    end
  end
end
