defmodule Erlef.Context do
  @moduledoc """
  Context module helpers
  """

  def audit_attrs(:create, params, audit) do
    case all_atoms_map?(params) do
      true ->
        params
        |> Map.put(:created_by, audit.member_id)
        |> Map.put(:updated_by, audit.member_id)

      false ->
        params
        |> Map.put("created_by", audit.member_id)
        |> Map.put("updated_by", audit.member_id)
    end
  end

  def audit_attrs(:update, params, audit) do
    case all_atoms_map?(params) do
      true ->
        Map.put(params, :updated_by, audit.member_id)

      false ->
        Map.put(params, "updated_by", audit.member_id)
    end
  end

  def all_atoms_map?(map), do: Enum.all?(Map.keys(map), &is_atom/1)
end
