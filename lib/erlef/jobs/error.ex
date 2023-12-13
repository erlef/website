defmodule Erlef.Jobs.Error do
  @moduledoc """
  A consolidated structure to represent an error in the Jobs context.
  """

  @type reason ::
          {:changeset, Ecto.Changeset.t()}
          | :unathorized
          | :post_quota_reached

  @type t :: %__MODULE__{
          reason: term()
        }

  defexception [:reason]

  @doc """
  Constructs a new error struct with the provided reason.
  """
  def exception(reason), do: %__MODULE__{reason: reason}

  @doc """
  Returns the error's message.
  """
  def message(%__MODULE__{reason: reason}), do: Erlef.Jobs.format_error(reason)
end
