defmodule Erlef.Mailer do
  @moduledoc """
  Erlef.Mailer
  """

  use Swoosh.Mailer, otp_app: :erlef

  def send(email) do
    deliver(email, config())
  end

  defp config do
    base_config = Application.get_env(:erlef, __MODULE__)
    user = System.get_env("SMTP_USER")
    passwd = System.get_env("SMTP_PASSWORD")
    Keyword.merge(base_config, username: user, password: passwd)
  end
end
