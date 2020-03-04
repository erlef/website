Application.ensure_all_started(:erlef)

event_types = [
  %{name: "conference"},
  %{name: "training"},
  %{name: "meetup"},
  %{name: "hackathon"}
]

Erlef.Data.Seeds.insert(Erlef.Data.Schema.EventType, event_types)

%{id: conf_id} = Erlef.Data.Schema.EventType.get(:conference)
%{id: meetup_id} = Erlef.Data.Schema.EventType.get(:meetup)
%{id: hackathon_id} = Erlef.Data.Schema.EventType.get(:hackathon)

now = DateTime.truncate(DateTime.utc_now(), :second)

events = [
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Code Elixir LDN is a one-day, one track conference bringing together the Elixir community to share, learn and be inspired. The conference is suitable for all levels of programming experience and all team members, from developers to CTOs and above.</p>\n<p>Attend Code Elixir LDN, meet like-minded professionals, find opportunities with companies using Elixir, grow your career, knowledge, contacts and team.</p>\n<p>Code Elixir LDN actively encourages diversity in the Elixir community</p>\n",
    end: ~D[2019-07-18],
    organizer: "Code Sync Ltd",
    organizer_brand_color: "#235185",
    start: ~D[2019-07-18],
    submitted_by: 0,
    title: "Code Elixir LDN",
    slug: "code-elixir-ldn",
    url: "https://codesync.global/conferences/code-elixir-ldn-2019/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>For the first time we’re bringing Code BEAM Lite to Budapest, financial center of Hungary. Code BEAM Lite conferences, are community lead conferences that strive to engage the local Erlang and Elixir ecosystem by bringing together developers to share knowledge &amp; ideas, learn from each other and inspire them to invent the future.</p>\n",
    end: ~D[2019-09-20],
    organizer: "Code Sync Ltd ",
    organizer_brand_color: "#235185",
    start: ~D[2019-09-20],
    submitted_by: 0,
    title: "Code BEAM Lite Budapest",
    slug: "code-beam-lite-budapest",
    url: "https://codesync.global/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>ElixirConf® JP 2019 demonstrates business examples using Elixir, Web services / subscription business / energy utilization platform / technology and development know-how to realize IoT with Elixir, and future industrial base and economy. See <a href=\"https://fukuokaex.fun\">https://fukuokaex.fun</a>/ for details.</p>\n",
    end: ~D[2019-09-07],
    organizer: "Kyushu International Elixir Federation (KIEF)",
    organizer_brand_color: "#235185",
    organizer_brand_logo: nil,
    start: ~D[2019-09-07],
    submitted_by: 0,
    title: "ElixirConf Japan",
    slug: "elixirconf-japan",
    url: "https://fukuokaex.fun/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: hackathon_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Spawnfest is an annual 48 hour free online development competition in which teams of skilled developers from around the world get exactly one weekend to create the best BEAM-based applications they can.</p>\n",
    end: ~D[2019-09-22],
    organizer: "SpawnFest",
    organizer_brand_color: "#235185",
    start: ~D[2019-09-21],
    submitted_by: 0,
    title: "Spawnfest 2019",
    slug: "spawnfest-2019",
    url: "https://spawnfest.github.io/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Join us for another fantastic conference in Berlin. Develop your understanding\nof the key concepts around Erlang, Elixir and the BEAM. Discover new\nframeworks and learn new libraries. Network with others through\nthe ‘hallway track,’ make new contacts and have fun! </p>\n",
    end: ~D[2019-10-11],
    organizer: "Code Sync Ltd ",
    organizer_brand_color: "#235185",
    start: ~D[2019-10-11],
    submitted_by: 0,
    title: "Code BEAM Lite Berlin",
    slug: "code-beam-lite-berlin",
    url: "https://codesync.global/conferences/code-beam-lite-berlin-2019/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Gig City Elixir is a different kind of programming conference in beautiful Chattanooga, Tennessee. We will focus on sessions that are different from what you’re used to seeing, with a variety of talk lengths and formats that will open more learning channels than ever before.</p>\n<p>One of the best speaker lineups at any 2019 programming conference will teach you the foundational techniques you’ll need to succeed in today’s programming industry. You’ll learn to use functional programming concepts that will make you a better programmer, regardless of the languages and tools you use at work today.</p>\n",
    end: ~D[2019-10-19],
    organizer: "GigCity Elixir ",
    organizer_brand_color: "#235185",
    organizer_brand_logo: nil,
    start: ~D[2019-10-17],
    submitted_by: 0,
    title: "GigCity Elixir 2019",
    slug: "gigcity-elixir-2019",
    url: "https://www.gigcityelixir.com/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Lonestar Elixir is a 2-day single track conference (with one extra day of training). Come for the Elixir knowledge. Stay for the parties and social mixing of Elixir enthusiasts.</p>\n<h3>Conference</h3>\n<p>Conference on 2/27-2/28 @\nAlamo Drafthouse\n1120 S Lamar Blvd, Austin, TX 78704</p>\n<h3>Training</h3>\n<p>Training on 2/29 @\nThe Capital Factory\n701 Brazos St., Austin, Texas 78701</p>\n",
    end: ~D[2020-02-29],
    organizer: "Lonestar Elixir",
    organizer_brand_color: "#235185",
    organizer_brand_logo: "/images/lonestar-elixir.svg",
    start: ~D[2020-02-27],
    submitted_by: 0,
    title: "Lonestar Elixir 2020",
    slug: "lonestar-elixir-2020",
    url: "https://www.lonestarelixir.com/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: meetup_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Pour démarrer l’autonne, nous serons hébergé chez Stuart: <a href=\"https://stuart.com\">https://stuart.com</a> (merci à eux!). Une fois encore ce sera un meetup commun avec le meetup Elixir.</p>\n<p>Proposez nous un sujet ici : <a href=\"https://tinyurl.com/erlang-paris\">https://tinyurl.com/erlang-paris</a></p>\n<p>Au programme :</p>\n<ul>\n<li>Nicolas SAVOIS nous parlera du Pattern Actor dans Elixir.\n</li>\n<li>et votre talks a vous !\n</li>\n</ul>\n<p>Ce meetup existe grâce à vos propositions de sujet ! Proposez nous des sujets en m’envoyant un message</p>\n<p>Si vous souhaitez héberger le Meetup Erlang faites nous un message ça sera avec plaisir !</p>\n",
    end: ~D[2019-10-08],
    organizer: "Benoît C.",
    organizer_brand_color: "#235185",
    start: ~D[2019-10-08],
    submitted_by: 0,
    title: "Erlang & Elixir Paris meetup 2019-10",
    slug: "erlang-elixir-paris-meetup-2019-10",
    url: "https://www.meetup.com/Erlang-Paris/events/265207130/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Elixir Conf is one of the most popular Conferences for the Elixir Programming Language and for the first time it will be hosted in Latin America, Medellin, Colombia. It is a two day conference with workshops and a amazing list of keynote speakers with very interesting topics. Thanks to all of our sponsors, speakers and attendees that are making this event possible.</p>\n<p>The first conference day will start with a two hands-on workshops where we will learn about functional programming and how to get the most out of Erlang/OTP with RIAK Core. On the second day, keynote speakers will have the floor to share their knowledge on a variety of topics for a diverse audience; closing up with Francesco Cessarini’s keynote. </p>\n",
    end: ~D[2019-10-25],
    organizer: "Elixir Conf ",
    organizer_brand_color: "#235185",
    start: ~D[2019-10-24],
    submitted_by: 0,
    title: "Elixir ConfLA 2019",
    slug: "elixir-confla-2019",
    url: "https://www.elixirconf.la/",
    inserted_at: now,
    updated_at: now
  },
  %{event_type_id: meetup_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Rendez-vous l’année prochaine pour le prochain Meetup Erlang &amp; Elixir. Nous serons cette fois hébergé par Booking.com (<a href=\"https://www.booking.com\">https://www.booking.com</a>) ! Merci à eux!</p>\n<p>Au programme, deux présentations et des discussion informelles.</p>\n<p>Les présentations:</p>\n<p>Nicolas Talfer nous présentera un retour d’expérience dans le cadre d’un appel d’offres pour un opérateur de téléphonie mobile en Amérique Latine, j’ai réalisé pour Myriad un poc de S@T gateway en Elixir. L’opérateur souhaite envoyer des offres promotionnelles via des applications SIM Toolkit déployées over-the-air. Au menu : transcoding XML, utilisation des records Erlang en Elixir, manipulation de binaires et cryptographie…</p>\n<p>Florent Gallaire nous présentera Metaprogramming en Erlang et Elixir, une comparaison par l’exemple</p>\n<p>Pour le prochain meetup, proposez nous un sujet ici: <a href=\"https://tinyurl.com/erlang-paris\">https://tinyurl.com/erlang-paris</a> . Des questions, besoin d’aide pour votre présentation, n’hésitez pas à me contacter!</p>\n<p>Si vous souhaitez héberger le prochain Meetup envoyez moi un message!</p>\n<p>Pour démarrer l’autonne, nous serons hébergé chez Stuart: <a href=\"https://stuart.com\">https://stuart.com</a> (merci à eux!). Une fois encore ce sera un meetup commun avec le meetup Elixir.</p>\n",
    end: ~D[2020-01-21],
    organizer: "Benoît C.",
    organizer_brand_color: "#235185",
    start: ~D[2020-01-21],
    submitted_by: 0,
    title: "Erlang & Elixir Paris meetup 2020-01",
    slug: "erlang-elixir-paris-meetup-2020-01",
    url: "https://www.meetup.com/Erlang-Paris/events/267270583/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>At FOSDEM 2020 we’re having the 1st edition of a Devroom completely dedicated to the BEAM (and all languages running on it). FOSDEM is an annual conference about free and open source software, attended by over 5000 developers and open-source enthusiasts from all over the world.</p>\n<p>The Devroom will take place on Saturday, 1 February 2020, at ULB (Campus Solbosch), in Brussels, Belgium. Join us to enjoy interesting talks, demos and discussions about Erlang, Elixir and the wonderful BEAM!</p>\n<p>The schedule is already live – click <a href=\"https://beam-fosdem.org/schedule/\">here</a> to check it! We hope to meet you in Brussels 🇧🇪</p>\n",
    end: ~D[2020-02-01],
    organizer: "BEAM FOSDEM",
    organizer_brand_color: "#A91F91",
    organizer_brand_logo: "/images/fosdem_circle.png",
    start: ~D[2020-02-01],
    submitted_by: 0,
    title: "BEAM FOSDEM",
    slug: "beam-fosdem",
    url: "https://beam-fosdem.org/schedule/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Join us at <a href=\"https://www2.codesync.global/l/23452/2020-02-04/6w4q3s\">Code BEAM SF</a> (San Francisco, 05-06 March 2020), the only conference in North America to cover Erlang and Elixir! </p>\n<p>2020 themes include Web and APIs, Frameworks, Scalability, Reliability, Containerization (Docker, Kubernetes), and integrating third party services. Learn from 50+ cutting-edge talks and our in-depth training program, how BEAM languages are revolutionising areas like IoT, Blockchain, Fintech, Security, Machine Learning and more. </p>\n<p>If you are new to BEAM languages or an old hand and want to extend your knowledge, we offer extensive basic and advanced OTP, Erlang, and Elixir training options.</p>\n<p>A limited number of standard tickets are still available! <a href=\"https://www2.codesync.global/l/23452/2020-02-04/6w4q3x\">Book now</a>!</p>\n",
    end: ~D[2020-03-06],
    organizer: "Code Sync",
    organizer_brand_color: "#ff0160",
    organizer_brand_logo: "/images/code-sync.svg",
    start: ~D[2020-03-05],
    submitted_by: 0,
    title: "Code BEAM SF 2020",
    slug: "code-beam-sf-2020",
    url: "https://www2.codesync.global/l/23452/2020-02-04/6w4q3s",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Erlang and Elixir technology is at the heart of many of the world’s leading tech stacks! Join us at <a href=\"https://www2.codesync.global/l/23452/2020-02-04/6w4y9d\">Code BEAM STO</a> (Stockholm, 28-29 May 2020), the only conference in Europe to bring Erlang, Elixir, and all of the languages on the Erlang VM together! </p>\n<p>2020 themes include Web and APIs, Frameworks, Scalability, Reliability, Containerization (Docker, Kubernetes), and integrating third party services. Learn from 50+ cutting-edge talks and our in-depth training program, how BEAM languages are revolutionising areas like IoT, Blockchain, Fintech, Security, Machine Learning and more. </p>\n<p>If you are new to BEAM languages or an old hand and want to extend your knowledge, we offer extensive basic and advanced OTP, Erlang, and Elixir training options.</p>\n<p>Tickets are on sale now! <a href=\"https://www2.codesync.global/l/23452/2020-02-04/6w4ybg\">Book now</a>!</p>\n",
    end: ~D[2020-05-29],
    organizer: "Code Sync",
    organizer_brand_color: "#235185",
    organizer_brand_logo: "/images/code-sync.svg",
    start: ~D[2020-05-28],
    submitted_by: 0,
    title: "Code BEAM STO 2020",
    slug: "code-beam-sto-2020",
    url: "https://www2.codesync.global/l/23452/2020-02-04/6w4y9d",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>Code BEAM Lite Italy is a one-day community-driven conference aimed at discovering the future of the Erlang Ecosystems and bringing together developers to share knowledge &amp; ideas, learn from each other and be inspired to invent the future. </p>\n",
    end: ~D[2020-04-06],
    organizer: "Code BEAM Lite ITA",
    organizer_brand_color: "#235185",
    organizer_brand_logo: "/images/code-beam-lite.png",
    start: ~D[2020-04-06],
    submitted_by: 0,
    title: "Code BEAM Lite ITA",
    slug: "code-beam-lite-ita",
    url: "https://codesync.global/conferences/code-beam-lite-italy-2020/",
    inserted_at: now,
    updated_at: now
  },
  %{
    event_type_id: conf_id,
    approved: true,
    approved_at: ~U[2020-03-02 17:03:01Z],
    approved_by: 0,
    description:
      "<p>The conference is a melting pot for new ideas and inspired thinking.\nIt showcases the great work being done with Elixir by individuals and companies alike.\nIt helps those new to the community find their feet, and welcomes back those who have attended before, to champion and progress the uptake and development of Elixir in Europe.</p>\n",
    end: ~D[2020-04-30],
    organizer: "Elixirconf EU",
    organizer_brand_color: "#235185",
    organizer_brand_logo: "/images/elixir-conf-logo.svg",
    start: ~D[2020-04-29],
    submitted_by: 0,
    title: "ElixirConf EU",
    slug: "elixirconf-eu",
    url: "https://www.elixirconf.eu/",
    inserted_at: now,
    updated_at: now
  }
]

Erlef.Data.Seeds.insert(Erlef.Data.Schema.Event, events)
