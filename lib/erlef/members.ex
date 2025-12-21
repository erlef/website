defmodule Erlef.Members do
  @moduledoc """
  Members context
  """

  alias Erlef.Members.Notifications
  alias Erlef.Mailer

  def notify(type, params) do
    type
    |> Notifications.new(params)
    |> Mailer.deliver()
  end
end
