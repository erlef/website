defmodule Erlef.Blogs.Config do
  @configs Application.get_env(:erlef, :blogs)

  def get(name) do
    :proplists.get_value(name, @configs)
  end

  def repo_for(name) do
    name
    |> get()
    |> fetch(:repo)
  end

  def about_for(name) do
    name
    |> get()
    |> fetch(:about)
  end

  defp fetch(:undefined, _key), do: nil
  defp fetch(nil, _key), do: nil
  defp fetch(map, key), do: Map.get(map, key)
end
