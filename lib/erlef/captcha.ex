defmodule Erlef.Captcha do
  def verify_recaptcha(response) do
    body = URI.encode_query(response: response, secret: System.get_env("RECAPTCHA_SECRET_KEY"))

    headers = [
      {"Content-type", "application/x-www-form-urlencoded"},
      {"Accept", "application/json"}
    ]

    url = "https://www.google.com/recaptcha/api/siteverify"

    secret = System.get_env("RECAPTCHA_SECRET_KEY")

    {:ok, 200, _, ref} = :hackney.post(url, headers, body, timeout: 5000, secret: secret)

    {:ok, body} = :hackney.body(ref)

    case Jason.decode(body) do
      {:ok, %{"success" => true}} -> {:ok, :verified}
      _ -> {:error, "Invalid recaptcha response"}
    end
  end
end
