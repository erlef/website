defmodule Erlef.Captcha do
  @moduledoc """
  Erlef.Captcha - Captcha related verification functions
  """
  @recaptch_url Application.get_env(:erlef, :recaptcha_url)

  def verify_recaptcha(response) do
    body = URI.encode_query(response: response, secret: System.get_env("RECAPTCHA_SECRET_KEY"))

    headers = [
      {"Content-type", "application/x-www-form-urlencoded"},
      {"Accept", "application/json"}
    ]

    secret = System.get_env("RECAPTCHA_SECRET_KEY")

    opts = [timeout: 5000, secret: secret]

    case Erlef.HTTP.perform(:post, @recaptch_url, headers, body, opts) do
      {:ok, %{body: %{"success" => true}}} ->
        {:ok, :verified}

      _err ->
        {:error, "Invalid recaptcha response"}
    end
  end
end
