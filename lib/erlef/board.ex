defmodule Erlef.Board do
  @roster [
    %{image: "francesco-cesarini.jpg", name: "Francesco Cesarini"},
    %{image: "jose-valim.jpg", name: "Jose Valim"},
    %{image: "richard-carlsson.jpg", name: "Richard Carlsson"},
    %{image: "sebastian-strollo.jpg", name: "Sebastion Strollo"},
    %{image: "miriam-pena.jpg", name: "Miriam Pena"}
  ]

  def members do
    @roster
  end
end
