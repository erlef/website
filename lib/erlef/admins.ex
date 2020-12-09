defmodule Erlef.Admins do
  @moduledoc false

  alias Erlef.Admins.Notifications
  alias Erlef.Mailer

  def notify(type, params \\ %{}) do
    type
    |> Notifications.new(params)
    |> Mailer.deliver()
  end
end
