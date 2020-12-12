defmodule Erlef do
  @moduledoc false

  @spec in_env?([atom()]) :: boolean()
  def in_env?(envs), do: Application.get_env(:erlef, :env) in envs

  @spec is_env?(atom) :: boolean()
  def is_env?(env), do: Application.get_env(:erlef, :env) == env

  def data_path(path) do
    List.to_string(:code.priv_dir(:erlef)) <> "/data/#{path}"
  end

  def get_data(path) do
    {term, _binding} = Code.eval_file(data_path(path))
    term
  end
end
