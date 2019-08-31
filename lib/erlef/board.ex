defmodule Erlef.Board do
  @roster [
    %{image: "francesco-cesarini.jpg", name: "Francesco Cesarini"},
    %{image: "jose-valim.jpg", name: "José Valim"},
    %{image: "richard-carlsson.jpg", name: "Richard Carlsson"},
    %{image: "sebastian-strollo.jpg", name: "Sebastion Strollo"},
    %{image: "benoit-chesneau.png", name: "Benoit Chesneau"},
    %{image: "fred-hebert.jpg", name: "Fred Hebert"},
    %{image: "miriam-pena.jpg", name: "Miriam Pena"},
    %{image: "alistair-woodman.png", name: "Alistair Woodman"},
    %{image: "maxim-fedorov.png", name: "Maxim Fedorov"},
    %{image: "kenneth-lundin.png", name: "Kenneth Lundin"},
    %{image: "peer-stritzinger.png", name: "Peer Stitzinger"}
  ]

  def members do
    @roster
  end
end
