use Mix.Config

# NOTE: The entry for EEF is hack for the current implementation of the blog controller and should be dealt with
# after the site is initial site re-design

config :erlef, :working_groups, [
  %{
    name: "Erlang Ecosystem Foundation",
    slug: "eef",
    description: "Find all the related news of the Erlang Ecosystem Foundation",
    primary_contact_method: "email",
    email: "eef@erlef.org",
    formed: "2019-04-30"
  },
  %{
    name: "Documentation",
    slug: "documentation",
    description:
      "Improve the accessibility, interoperability and quality of the documentation across projects and languages in the Erlang Ecosystem.",
    primary_contact_method: "email",
    email: "documentation@erlef.org",
    formed: ~D[2019-07-23],
    members: [
      %{image: "members/jose-valim.jpg", name: "José Valim"},
      %{image: "members/fred-hebert.jpg", name: "Fred Hebert"},
      %{image: "members/kenneth-lundin.jpg", name: "Kenneth Lundin"},
      %{image: "members/mariano-guerra.jpg", name: "Mariano Guerra"},
      %{image: "members/profile-placeholder.png", name: "Radosław Szymczyszyn"},
      %{image: "members/laszlo-bacsi.png", name: "László Bácsi"}
    ]
  },
  %{
    name: "Observability",
    slug: "observability",
    description:
      "To evolve the tools in the ecosystem related to observability, such as metrics, distributed tracing and logging, with a strong focus on interoperability between BEAM languages.",
    primary_contact_method: "github",
    github: "https://github.com/erlef/eef-observability-wg",
    gcal_url:
      "https://calendar.google.com/calendar?cid=N25nZ2RiNWhuZnFwODI4b2FwaTExOWprZXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ",
    formed: ~D[2019-04-30],
    members: [
      %{image: "members/tristan-sloughter.jpg", name: "Tristan Sloughter"},
      %{image: "members/lukasz-niemier.jpg", name: "Łukasz Niemier"},
      %{image: "members/vince-foley.png", name: "Vince Foley"},
      %{image: "members/ilya-khaprov.jpg", name: "Ilya Khaprov"},
      %{image: "members/bryan-naegele.png", name: "Bryan Naegele"},
      %{image: "members/greg-mefford.jpg", name: "Greg Mefford"},
      %{image: "members/arkadiusz-gil.jpg", name: "Arkadiusz Gil"},
      %{image: "members/zachary-daniel.jpg", name: "Zach Daniel"},
      %{image: "members/mark-allen.jpg", name: "Mark Allen"},
      %{image: "members/andrew-thompson.jpg", name: "Andrew Thompson"},
      %{image: "members/jose-valim.jpg", name: "José Valim"}
    ]
  },
  %{
    name: "Security",
    slug: "security",
    description:
      "The mission of the Security Working Group is to identify security issues, and provide solutions, develop guidance, standards, technical mechanisms and documentation.",
    primary_contact_method: "email",
    email: "security@erlef.org",
    formed: ~D[2019-04-30],
    members: [
      %{image: "members/bram-verburg.jpg", name: "Bram Verburg"},
      %{image: "members/profile-placeholder.png", name: "Maxim Fedorov"},
      %{image: "members/profile-placeholder.png", name: "Alexandre Rodrigues"},
      %{image: "members/profile-placeholder.png", name: "Hans Nilsson"},
      %{image: "members/profile-placeholder.png", name: "Peter Dimitrov"},
      %{image: "members/profile-placeholder.png", name: "Griffin Byatt"},
      %{image: "members/profile-placeholder.png", name: "Duncan Sparrell"},
      %{image: "members/drew-varner.jpg", name: "Drew Varner"}
    ]
  },
  %{
    name: "Marketing",
    slug: "marketing",
    description:
      "To expand awareness of Erlang Ecosystem and participation in its community. To promote the Erlang Ecosystem Foundation and its activities, and to increase engagement in the foundation.",
    primary_contact_method: "email",
    email: "marketing@erlef.org",
    formed: ~D[2018-10-15],
    members: [
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
  },
  %{
    name: "Building and Packaging",
    slug: "building",
    description:
      "To evolve the tools in the ecosystem related to building and deploying code, with a strong focus on interoperability between BEAM languages",
    primary_contact_method: "github",
    github: "https://github.com/erlef/eef-build-and-packaging-wg",
    formed: ~D[2019-04-30],
    members: [
      %{image: "members/tristan-sloughter.jpg", name: "Tristan Sloughter"},
      %{image: "members/fred-hebert.jpg", name: "Fred Hebert"},
      %{image: "members/bryan-paxton.jpg", name: "Bryan Paxton"},
      %{image: "members/todd-resudek.jpg", name: "Todd Resudek"},
      %{image: "members/randy-thompson.jpg", name: "Randy Thompson"},
      %{image: "members/wojtek-mach.jpg", name: "Wojtek Mach"},
      %{image: "members/profile-placeholder.png", name: "Ivan Glushkov"},
      %{image: "members/andrea-leopardi.jpg", name: "Andrea Leopardi"},
      %{image: "members/profile-placeholder.png", name: "Justin Wood"}
    ]
  },
  %{
    name: "Education, Training, & Adoption",
    slug: "education",
    description:
      "Facilitate, evolve education and training and consolidate educational material(s) for all BEAM languages and the BEAM itself.",
    primary_contact: "email",
    email: "education@erlef.org",
    formed: ~D[2019-06-15],
    members: [
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
      %{image: "members/alistair-woodman.png", name: "Alistair Woodman"},
      %{image: "members/paulo-d-gonzalez.png", name: "Paulo D. Gonzalez"},
      %{image: "members/norberto-ortigoza.jpg", name: "Norberto Ortigoza"},
      %{image: "members/todd-resudek.jpg", name: "Todd Resudek"}
    ]
  },
  %{
    name: "Fellowship",
    slug: "fellowship",
    description:
      "To formally nominate community members for a fellowship role according to the Erlang Ecosystem Foundation bylaws.  Creating and maintaining the criteria and procedure for nomination of fellows.",
    primary_contact_method: "email",
    email: "fellows@erlef.org",
    formed: ~D[2019-04-30],
    members: [
      %{image: "members/francesco-cesarini.jpg", name: "Francesco Cesarini"},
      %{image: "members/profile-placeholder.png", name: "Benoit Chesneau"},
      %{image: "members/jose-valim.jpg", name: "José Valim"},
      %{image: "members/kenneth-lundin.jpg", name: "Kenneth Lundin"}
    ]
  },
  %{
    name: "Sponsorship",
    slug: "sponsorship",
    description: "To approve Erlang Ecosystem Foundation Sponsor candidacy.",
    primary_contact_method: "email",
    email: "sponsorship@erlef.org",
    formed: ~D[2019-04-30],
    members: [
      %{image: "members/francesco-cesarini.jpg", name: "Francesco Cesarini"},
      %{image: "members/sebastian-strollo.jpg", name: "Sebastion Strollo"},
      %{image: "members/profile-placeholder.png", name: "Benoit Chesneau"},
      %{image: "members/profile-placeholder.png", name: "Alistair Woodman"},
      %{image: "members/peer-stritzinger.jpg", name: "Peer Stritzinger"}
    ]
  },
  %{
    name: "Embedded Systems",
    slug: "embedded-systems",
    description:
      "Standardize, improve, and promote the APIs, tooling, and infrastructure for building embedded systems and IoT devices usingErlang VMs",
    primary_contact_method: "email",
    email: "embedded-systems@erlef.org",
    formed: ~D[2019-08-09],
    members: [
      %{image: "members/peer-stritzinger.jpg", name: "Peer Stritzinger"},
      %{image: "members/adam-lindberg.jpg", name: "Adam Lindberg"},
      %{image: "members/profile-placeholder.png", name: "Frank Hunleth"},
      %{image: "members/profile-placeholder.png", name: "Justin Schneck"},
      %{image: "members/profile-placeholder.png", name: "Hideki Takase"},
    ]
  },
]
