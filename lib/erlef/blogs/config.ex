defmodule Erlef.Blogs.Config do
  @configs Application.get_env(:erlef, :blogs)

  def get(name) do
    :proplists.get_value(name, @configs)
  end

  def module_for(name) do
    name
    |> get()
    |> Map.get(:module)
  end

  def about_for(name) do
    name
    |> get()
    |> Map.get(:about)
  end
end
