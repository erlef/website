defmodule Erlef.StipendProposal do
  @moduledoc """
    Erlef.StipendProposal
  """

  # The string version of the key name followed by
  # a tuple consisting of the atom version of the key,
  # a second atom declaring its type or a tuple declaring its type and size
  #
  @string_key_map %{
    "first_name" => {:first_name, {:binary, 50}},
    "last_name" => {:last_name, {:binary, 50}},
    "nick_name" => {:nick_name, {:binary, 50}},
    "email_address" => {:email_address, {:binary, 50}},
    "phone_number" => {:phone_number, {:binary, 20}},
    "org_name" => {:org_name, {:binary, 50}},
    "org_email" => {:org_email, :binary},
    "city" => {:city, {:binary, 85}},
    "region" => {:region, {:binary, 50}},
    "country" => {:country, {:binary, 50}},
    "postal_code" => {:postal_code, {:binary, 10}},
    "twitter" => {:twitter, {:binary, 50}},
    "linkedin" => {:linkedin, {:binary, 50}},
    "website" => {:website, {:binary, 50}},
    "bio" => {:bio, {:binary, 5000}},
    "code_of_conduct_link" => {:code_of_conduct_link, {:binary, 50}},
    "files" => {:files, :list},
    "purpose" => {:purpose, {:binary, 5000}},
    "stipend_type" => {:stipend_type, {:binary, 25}},
    "stipend_amount" => {:stipend_amount, {:binary, 50}},
    "payment_method" => {:payment_method, {:binary, 6}},
    "beneficiaries" => {:beneficiaries, {:binary, 5000}},
    "report" => {:report, {:binary, 5000}}
  }

  defstruct Map.values(@string_key_map)

  def from_map(params) do
    kept = Map.take(params, Map.keys(@string_key_map))

    {proposal, errors} =
      Enum.reduce(kept, {%__MODULE__{}, []}, fn {k, v}, {acc, errs} ->
        {key, t} = Map.get(@string_key_map, k)

        case validate(t, k, v) do
          {:ok, ^k, ^v} ->
            {%{acc | key => v}, errs}

          {:error, reason} ->
            {acc, [reason] ++ errs}
        end
      end)

    case errors do
      [] ->
        {:ok, proposal}

      errors ->
        {:error, errors}
    end
  end

  defp validate({:binary, length}, key, val) when is_binary(val) and byte_size(val) <= length do
    {:ok, key, val}
  end

  defp validate({:binary, length}, key, _val), do: {:error, "invalid #{key} - max size #{length}"}

  defp validate(:binary, key, val) when is_binary(val), do: {:ok, key, val}

  defp validate(:list, key, val) when is_list(val), do: {:ok, key, val}
end
