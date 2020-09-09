defmodule Erlef.AcademicPapers do
  @moduledoc """
  Context responsible for managing Academic Papers
  """

  @doc """
  Using this stub for now. If we ever want to replace the datastore, we can.

  Date convention: If you are only given a year, make the date Jan 1st for that
  year.
  """
  def all() do
    [
      %{
        link: "http://erlang.org/download/armstrong_thesis_2003.pdf",
        name: "Making reliable distributed systems in the presence of software errors",
        tags: "Erlang",
        date: Date.new(2003, 12, 1)
      },
      %{
        link:
          "https://www.researchgate.net/profile/Phil_Trinder/publication/221211369_Comparing_C_and_ERLANG_for_motorola_telecoms_software/links/570fb77408aec95f061589cb/Comparing-C-and-ERLANG-for-motorola-telecoms-software.pdf",
        name: "Comparing C++ and ERLANG for motorola telecoms software",
        tags: "Erlang",
        date: Date.new(2006, 1, 1)
      },
      %{
        link:
          "https://kth.diva-portal.org/smash/record.jsf?searchId=2&pid=diva2%3A392243&dswid=-4049",
        name: "Characterizing the Scalability of Erlang VM on Many-core Processors",
        tags: "BEAM",
        date: Date.new(2011, 1, 1)
      },
      %{
        link: "https://jeena.net/t/GGS.pdf",
        name: "A Generic Game Server",
        tags: "Erlang, BEAM",
        date: Date.new(2011, 1, 1)
      },
      %{
        link: "https://pdfs.semanticscholar.org/cd4e/7b338616eb6a87a542aa224d5d1b3e7aee41.pdf",
        name: "SFMT pseudo random number generator for Erlang",
        tags: "Erlang, PRNG",
        date: Date.new(2011, 9, 23)
      },
      %{
        link:
          "https://www.researchgate.net/publication/254464022_TinyMT_pseudo_random_number_generator_for_Erlang",
        name: "TinyMT pseudo random number generator for Erlang",
        tags: "Erlang, PRNG",
        date: Date.new(2012, 9, 14)
      },
      %{
        link: "https://pdfs.semanticscholar.org/62c5/81a08fcb58cb89586486a949376d984a3303.pdf",
        name: "Multiplayer Game Server for Turn-Based Mobile Games in Erlang",
        tags: "Erlang, BEAM",
        date: Date.new(2013, 2, 1)
      },
      %{
        link: "https://staff.um.edu.mt/afra1/papers/rv13jour.pdf",
        name: "Synthesising correct concurrent runtime monitors",
        tags: "Erlang",
        date: Date.new(2014, 11, 20)
      },
      %{
        link: "http://ds.cs.ut.ee/courses/course-files/To303nis%20Pool%20.pdf",
        name: "Comparison of Erlang Runtime System and Java Virtual Machine",
        tags: "BEAM",
        date: Date.new(2015, 5, 1)
      },
      %{
        link: "http://www.dcs.gla.ac.uk/research/sd-erlang/sd-erlang-improving-jpdc-16.pdf",
        name: "Improving the Network Scalability of Erlang",
        tags: "Erlang",
        date: Date.new(2015, 8, 26)
      },
      %{
        link: "https://staff.um.edu.mt/afra1/papers/rv2016.pdf",
        name: "A Monitoring Tool for a Branching-Time Logic",
        tags: "Erlang",
        date: Date.new(2016, 5, 1)
      },
      %{
        link: "https://ieeexplore.ieee.org/document/7797392",
        name: "Elixir programming language evaluation for IoT (in Japanese)",
        tags: "Elixir",
        date: Date.new(2016, 9, 28)
      },
      %{
        link: "https://staff.um.edu.mt/afra1/papers/betty-book.pdf",
        name: "A Runtime Monitoring Tool for Actor-Based Systems",
        tags: "Erlang",
        date: Date.new(2017, 1, 1)
      },
      %{
        link: "http://www.dcs.gla.ac.uk/research/sd-erlang/release-summary-arxiv.pdf",
        name:
          "Scaling Reliably: Improving the Scalability of the Erlang Distributed Actor Platform",
        tags: "Erlang, BEAM",
        date: Date.new(2017, 4, 25)
      },
      %{
        link:
          "https://www.researchgate.net/publication/320360988_Sparrow_a_DSL_for_coordinating_large_groups_of_heterogeneous_actors",
        name: "Sparrow: a DSL for coordinating large groups of heterogeneous actors",
        tags: "Elixir",
        date: Date.new(2017, 9, 1)
      },
      %{
        link: "https://zeam-vm.github.io/papers/callback-thread-2nd-WSA.html",
        name:
          "Plan to Implementation of Lightweight Callback Thread for Elixir and Improvement of Maximum Concurrent Sessions and Latency of Phoenix (in Japanese)",
        tags: "Elixir",
        date: Date.new(2018, 5, 12)
      },
      %{
        link:
          "https://ipsj.ixsq.nii.ac.jp/ej/index.php?active_action=repository_view_main_item_detail&page_id=13&block_id=8&item_id=190322&item_no=1",
        name:
          "An Empirical Evaluation to Performance of Elixir for Introducing IoT Systems (in Japanese)",
        tags: "Elixir",
        date: Date.new(2018, 6, 29)
      },
      %{
        link:
          "https://ipsj.ixsq.nii.ac.jp/ej/index.php?active_action=repository_view_main_item_detail&page_id=13&block_id=8&item_id=190626&item_no=1",
        name:
          "Implementation of Runtime Environments of C++ and Elixir with the Node Programming Model (in Japanese)",
        tags: "Elixir",
        date: Date.new(2018, 7, 23)
      },
      %{
        link: "https://researchmap.jp/?action=cv_download_main&upload_id=192105",
        name:
          "A Method Using GPGPU for Super-Parallelization in Elixir Programming (in Japanese)",
        tags: "Elixir",
        date: Date.new(2018, 8, 1)
      },
      %{
        link: "https://ci.nii.ac.jp/naid/170000150470/",
        name:
          "Hastega: Parallelization of Linear Regression Using SIMD Instruction for Elixir Programming (in Japanese)",
        tags: "Elixir",
        date: Date.new(2018, 1, 17)
      },
      %{
        link: "https://ci.nii.ac.jp/naid/170000180471/",
        name:
          "SumMag: Design and Implementation of an Analyzer an Extension Mechanism by Meta-programming Using Elixir Macros (in Japanese)",
        tags: "Elixir",
        date: Date.new(2019, 3, 19)
      },
      %{
        link: "https://www.mdpi.com/1424-8220/19/18/4017/htm",
        name:
          "Elemental: An Open-Source Wireless Hardware and Software Platform for Building Energy and Indoor Environmental Monitoring and Control",
        tags: "Elixir, Nerves",
        date: Date.new(2019, 9, 18)
      },
      %{
        link: "https://www.info.ucl.ac.be/~pvr/Neirinckx_47311500_Bastin_81031400_2020.pdf",
        name: "Sensor fusion at the extreme edge of an internet of things network",
        tags: "Elixir, Nerves, Phoenix",
        date: Date.new(2020, 8, 16)
      }
    ]
  end
end
