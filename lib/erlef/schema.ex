defmodule Erlef.Schema do
  @moduledoc """
  Imports all functionality for an ecto schema

  ### Usage

  ```
  defmodule Erlef.Schema.MySchema do
    use Erlef.Schema

    schema "my_schemas" do
    # Fields
    end
  end
  ```
  """

  alias Erlef.Inputs
  import Ecto.Changeset

  defmacro __using__(_opts) do
    quote do
      alias __MODULE__
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Erlef.Schema
      import Ecto.Query, only: [from: 1, from: 2]

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime]
    end
  end

  @spec validate_email(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_email(cs, field) do
    case Map.get(cs.changes, field) do
      nil ->
        cs

      _ ->
        case Inputs.is_email?(Map.get(cs.changes, field)) do
          true ->
            cs

          false ->
            add_error(cs, field, "#{Atom.to_string(field)} is invalid.")
        end
    end
  end

  @spec validate_url(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_url(cs, field) do
    case Map.get(cs.changes, field) do
      nil ->
        cs

      _ ->
        case Inputs.is_url?(Map.get(cs.changes, field)) do
          true ->
            cs

          false ->
            msg = """
            #{humanize(field)} is invalid. Be sure the url consists of a scheme, host, and path parts.
            """

            add_error(cs, field, msg)
        end
    end
  end

  @spec humanize(atom | String.t()) :: String.t()
  def humanize(atom) when is_atom(atom),
    do: humanize(Atom.to_string(atom))

  def humanize(bin) when is_binary(bin) do
    bin =
      if String.ends_with?(bin, "_id") do
        binary_part(bin, 0, byte_size(bin) - 3)
      else
        bin
      end

    bin |> String.replace("_", " ") |> String.capitalize()
  end
end
