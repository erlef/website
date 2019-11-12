defmodule Erlef.AcademicPaper do
  @doc """
  Using this stub for now. If we ever want to replace the datastore, we can.
  """
  def all() do
    [
      %{
        link: "http://erlang.org/download/armstrong_thesis_2003.pdf",
        name: "Making reliable distributed systems in the presence of software errors",
        tags: ["Erlang"],
        date: Date.new(2003, 12, 1)
      },
      %{
        link: "http://erlang.org/download/armstrong_thesis_2003.pdf",
        name: "Making reliable distributed systems in the presence of software errors",
        tags: ["Erlang"],
        date: Date.new(2003, 12, 1)
      }
    ]
  end
end
