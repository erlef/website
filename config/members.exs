use Mix.Config

config :erlef, :rosters, [
  :board,
  :marketing,
  :security,
  :building,
  :education,
  :observability,
  :fellowship,
  :sponsorship,
  :documentation
]

config :erlef, :board, [
  %{image: "members/francesco-cesarini.jpg", name: "Francesco Cesarini"},
  %{image: "members/jose-valim.jpg", name: "José Valim"},
  %{image: "members/richard-carlsson.jpg", name: "Richard Carlsson"},
  %{image: "members/sebastian-strollo.jpg", name: "Sebastion Strollo"},
  %{image: "members/profile-placeholder.png", name: "Benoit Chesneau"},
  %{image: "members/fred-hebert.jpg", name: "Fred Hebert"},
  %{image: "members/miriam-pena.jpg", name: "Miriam Pena"},
  %{image: "members/profile-placeholder.png", name: "Alistair Woodman"},
  %{image: "members/profile-placeholder.png", name: "Maxim Fedorov"},
  %{image: "members/kenneth-lundin.jpg", name: "Kenneth Lundin"},
  %{image: "members/peer-stitzinger.jpg", name: "Peer Stritzinger"}
]

config :erlef, :marketing, [
  %{image: "members/bryan-paxton.jpg", name: "Bryan Paxton"},
  %{image: "members/profile-placeholder.png", name: "Benoit Chesneau"},
  %{image: "members/miriam-pena.jpg", name: "Miriam Pena"},
  %{image: "members/profile-placeholder.png", name: "Maxim Fedorov"},
  %{image: "members/desmond-bowe.png", name: "Desmond Bowe"},
  %{image: "members/brian-cardella.jpg", name: "Brian Cardella"},
  %{image: "members/profile-placeholder.png", name: "Johnny Winn"},
  %{image: "members/amos-king.png", name: "Amos King"},
  %{image: "members/ben-marx.jpg", name: "Ben Marx"},
  %{image: "members/profile-placeholder.png", name: "Magdalena Pokorska"}
]

config :erlef, :building, [
  %{image: "members/tristan-sloughter.jpg", name: "Tristan Sloughter"},
  %{image: "members/fred-hebert.jpg", name: "Fred Hebert"},
  %{image: "members/bryan-paxton.jpg", name: "Bryan Paxton"},
  %{image: "members/todd-resudek.jpg", name: "Todd Resudek"},
  %{image: "members/profile-placeholder.png", name: "Randy Thompson"},
  %{image: "members/wojtek-mach.jpg", name: "Wojtek Mach"}
]

config :erlef, :security, [
  %{image: "members/bram-verburg.jpg", name: "Bram Verburg"},
  %{image: "members/profile-placeholder.png", name: "Maxim Fedorov"},
  %{image: "members/profile-placeholder.png", name: "Alexandre Rodrigues"},
  %{image: "members/profile-placeholder.png", name: "Hans Nilsson"},
  %{image: "members/profile-placeholder.png", name: "Peter Dimitrov"},
  %{image: "members/profile-placeholder.png", name: "Griffin Byatt"},
  %{image: "members/profile-placeholder.png", name: "Duncan Sparrell"},
  %{image: "members/drew-varner.jpg", name: "Drew Varner"}
]

config :erlef, :observability, [
  %{image: "members/tristan-sloughter.jpg", name: "Tristan Sloughter"},
  %{image: "members/lukasz-niemier.jpg", name: "Łukasz Niemier"},
  %{image: "members/profile-placeholder.png", name: "Vince Foley"},
  %{image: "members/profile-placeholder.png", name: "Ilya Khaprov"},
  %{image: "members/bryan-naegele.png", name: "Bryan Naegele"},
  %{image: "members/greg-mefford.jpg", name: "Greg Mefford"},
  %{image: "members/profile-placeholder.png", name: "Arkadiusz Gil"},
  %{image: "members/zachary-daniel.jpg", name: "Zach Daniel"},
  %{image: "members/mark-allen.jpg", name: "Mark Allen"},
  %{image: "members/profile-placeholder.png", name: "Andrew Thompson"},
  %{image: "members/jose-valim.jpg", name: "José Valim"}
]

config :erlef, :documentation, [
  %{image: "members/jose-valim.jpg", name: "José Valim"},
  %{image: "members/fred-hebert.jpg", name: "Fred Hebert"},
  %{image: "members/kenneth-lundin.jpg", name: "Kenneth Lundin"},
  %{image: "members/mariano-guerra.jpg", name: "Mariano Guerra"},
  %{image: "members/profile-placeholder.png", name: "Radosław Szymczyszyn"},
  %{image: "members/laszlo-bacsi.png", name: "László Bácsi"}
]

config :erlef, :education, [
  %{image: "members/brujo-benavides.png", name: "Brujo Benavides"},
  %{image: "members/francesco-cesarini.jpg", name: "Francesco Cesarini"},
  %{image: "members/fred-hebert.jpg", name: "Fred Hebert"},
  %{image: "members/miriam-pena.jpg", name: "Miriam Pena"},
  %{image: "members/peer-stritzinger.jpg", name: "Peer Stritzinger"},
  %{image: "members/simon-thompson.jpg", name: "Simon Thompson"},
  %{image: "members/jeff-grunewald.jpg", name: "Jeff Grunewald"},
  %{image: "members//anna-neyzberg.jpg", name: "Anna Neyzberg"},
  %{image: "members/laura-castro.jpg", name: "Laura M. Castro"},
  %{image: "members/mrinal-wadhwa.png", name: "Mrinal Wadhwa"},
  %{image: "members/bryan-paxton.jpg", name: "Bryan Paxton"},
  %{image: "members/ben-marx.jpg", name: "Ben Marx"},
  %{image: "members/desmond-bowe.png", name: "Desmond Bowe"},
  %{image: "members/profile-placeholder.png", name: "Alistair Woodman"},
  %{image: "members/paulo-d-gonzalez.png", name: "Paulo D. Gonzalez"},
  %{image: "members/norberto-ortigoza.jpg", name: "Norberto Ortigoza"}
]

config :erlef, :fellowship, [
  %{image: "members/francesco-cesarini.jpg", name: "Francesco Cesarini"},
  %{image: "members/profile-placeholder.png", name: "Benoit Chesneau"},
  %{image: "members/jose-valim.jpg", name: "José Valim"},
  %{image: "members/kenneth-lundin.jpg", name: "Kenneth Lundin"}
]

config :erlef, :sponsorship, [
  %{image: "members/francesco-cesarini.jpg", name: "Francesco Cesarini"},
  %{image: "members/sebastian-strollo.jpg", name: "Sebastion Strollo"},
  %{image: "members/profile-placeholder.png", name: "Benoit Chesneau"},
  %{image: "members/profile-placeholder.png", name: "Alistair Woodman"},
  %{image: "members/peer-stritzinger.jpg", name: "Peer Stritzinger"}
]
