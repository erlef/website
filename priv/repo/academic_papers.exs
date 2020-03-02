Application.ensure_all_started(:erlef)

current_papers = [
  %{
    title: "Making reliable distributed systems in the presence of software errors",
    author: "Joe Armstrong",
    url: "http://erlang.org/download/armstrong_thesis_2003.pdf",
    language: "English",
    technologies: ["Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2003, 12, 1); date end).(),
    published_at: DateTime.utc_now(),
  },
  %{
    title: "Comparing C++ and ERLANG for motorola telecoms software",
    author: "Phil Trinder, J.H. Nystrom, D.J. King",
    url: "https://www.researchgate.net/profile/Phil_Trinder/publication/221211369_Comparing_C_and_ERLANG_for_motorola_telecoms_software/links/570fb77408aec95f061589cb/Comparing-C-and-ERLANG-for-motorola-telecoms-software.pdf",
    language: "English",
    technologies: ["Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2006, 1, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Characterizing the Scalability of Erlang VM on Many-core Processors",
    author: "Jianrong Zhang",
    url: "https://kth.diva-portal.org/smash/get/diva2:392243/FULLTEXT01.pdf",
    language: "English",
    technologies: ["BEAM", "Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2011, 1, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "A Generic Game Server",
    author: "Jonatan Pålsson, Richard Pannek, Niklas Landin, Mattias Petterson",
    url: "https://jeena.net/t/GGS.pdf",
    language: "English",
    technologies: ["BEAM", "Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2011, 1, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "SFMT pseudo random number generator for Erlang",
    author: "Kenji Rikitake",
    url: "https://pdfs.semanticscholar.org/cd4e/7b338616eb6a87a542aa224d5d1b3e7aee41.pdf",
    language: "English",
    technologies: ["Erlang", "PRNG"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2011, 9, 23); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "TinyMT pseudo random number generator for Erlang",
    author: "Kenji Rikitake",
    url: "https://www.researchgate.net/publication/254464022_TinyMT_pseudo_random_number_generator_for_Erlang",
    language: "English",
    technologies: ["Erlang", "PRNG"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2012, 9, 14); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Multiplayer Game Server for Turn-Based Mobile Games in Erlang",
    author: "Anders Andersson",
    url: "https://pdfs.semanticscholar.org/62c5/81a08fcb58cb89586486a949376d984a3303.pdf",
    language: "English",
    technologies: ["Erlang", "BEAM"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2013, 2, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Synthesising correct concurrent runtime monitors",
    author: "Adrian Francalanza, Aldrin Seychell",
    url: "https://staff.um.edu.mt/afra1/papers/rv13jour.pdf",
    language: "English",
    technologies: ["Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2014, 11, 20); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Comparison of Erlang Runtime System and Java Virtual Machine",
    author: "Tõnis Pool",
    url: "http://ds.cs.ut.ee/courses/course-files/To303nis%20Pool%20.pdf",
    language: "English",
    technologies: ["BEAM"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2015, 5, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Improving the Network Scalability of Erlang",
    author: "Natalia Chechina, Huiqing Li, Amir Ghaffari, Simon Thompson, Phil Trindera",
    url: "http://www.dcs.gla.ac.uk/research/sd-erlang/sd-erlang-improving-jpdc-16.pdf",
    language: "English",
    technologies: ["Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2015, 8, 26); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "A Monitoring Tool for a Branching-Time Logic",
    author: "Duncan Paul Attard, Adrian Francalanza",
    url: "https://staff.um.edu.mt/afra1/papers/rv2016.pdf",
    language: "English",
    technologies: ["Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2016, 5, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Elixir programming language evaluation for IoT",
    author: "Geovane Fedrecheski, Laisa C. P. Costa, Marcelo K. Zuffo",
    url: "https://ieeexplore.ieee.org/document/7797392",
    language: "English",
    technologies: ["Elixir"],
    pay_wall?: true,
    original_publish_date: (fn -> {:ok, date} = Date.new(2016, 9, 28); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "A Runtime Monitoring Tool for Actor-Based Systems",
    author: "Duncan Paul Attard, Ian Cassar, Adrian Francalanza, Luca Aceto, Anna Ingolfsdottir",
    url: "https://staff.um.edu.mt/afra1/papers/betty-book.pdf",
    language: "English",
    technologies: ["Erlang"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2017, 1, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Scaling Reliably: Improving the Scalability of the Erlang Distributed Actor Platform",
    author: "Phil Trinder, Natalia Chechina, Nikolaos Papaspyrou, Konstantinos Sagonas, Simon Thompson, et al.",
    url: "http://www.dcs.gla.ac.uk/research/sd-erlang/release-summary-arxiv.pdf",
    language: "English",
    technologies: ["Erlang", "BEAM"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2017, 4, 25); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Sparrow: a DSL for coordinating large groups of heterogeneous actors",
    author: "Humberto Rodriguez Avila, Joeri De Koster, Wolfgang De Meuter",
    url: "https://www.researchgate.net/publication/320360988_Sparrow_a_DSL_for_coordinating_large_groups_of_heterogeneous_actors",
    language: "English",
    technologies: ["Elixir"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2017, 9, 1); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Plan to Implementation of Lightweight Callback Thread for Elixir and Improvement of Maximum Concurrent Sessions and Latency of Phoenix",
    author: "Susumu Yamazaki",
    url: "https://zeam-vm.github.io/papers/callback-thread-2nd-WSA.html",
    language: "Japanese",
    technologies: ["Elixir"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2018, 5, 12); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "An Empirical Evaluation to Performance of Elixir for Introducing IoT Systems",
    author: "Unknown",
    url: "https://ipsj.ixsq.nii.ac.jp/ej/index.php?active_action=repository_view_main_item_detail&page_id=13&block_id=8&item_id=190322&item_no=1",
    language: "Japanese",
    technologies: ["Elixir"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2018, 6, 29); date end).()
  },
  %{
    title: "Implementation of Runtime Environments of C++ and Elixir with the Node Programming Model",
    author: "Unknown",
    url: "https://ipsj.ixsq.nii.ac.jp/ej/index.php?active_action=repository_view_main_item_detail&page_id=13&block_id=8&item_id=190626&item_no=1",
    language: "Japanese",
    technologies: ["Elixir"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2018, 7, 23); date end).()
  },
  %{
    title: "A Method Using GPGPU for Super-Parallelization in Elixir Programming",
    author: "Unknown",
    url: "https://researchmap.jp/?action=cv_download_main&upload_id=192105",
    language: "Japanese",
    technologies: ["Elixir"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2018, 8, 1); date end).()
  },
  %{
    title: "Hastega: Parallelization of Linear Regression Using SIMD Instruction for Elixir Programming",
    author: "Yuki Hisae, Susumu Yamazaki",
    url: "https://ci.nii.ac.jp/naid/170000150470/",
    language: "Japanese",
    technologies: ["Elixir"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2018, 1, 17); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    url: "https://ci.nii.ac.jp/naid/170000180471/",
    author: "Susumu Yamazaki, Yuki Hisae",
    title: "SumMag: Design and Implementation of an Analyzer an Extension Mechanism by Meta-programming Using Elixir Macros",
    language: "Japanese",
    technologies: ["Elixir"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2019, 3, 19); date end).(),
    published_at: DateTime.utc_now()
  },
  %{
    title: "Elemental: An Open-Source Wireless Hardware and Software Platform for Building Energy and Indoor Environmental Monitoring and Control",
    author: "Akram Syed Ali,Christopher Coté, Mohammad Heidarinejad, Brent Stephens",
    url: "https://www.mdpi.com/1424-8220/19/18/4017/htm",
    language: "English",
    technologies: ["Elixir", "Nerves"],
    pay_wall?: false,
    original_publish_date: (fn -> {:ok, date} = Date.new(2019, 9, 18); date end).(),
    published_at: DateTime.utc_now()
  }
]

Enum.each(current_papers, fn(paper) ->
  Erlef.Data.Query.AcademicPaper.create(paper)
end)
