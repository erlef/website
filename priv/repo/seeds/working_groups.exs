now = DateTime.truncate(DateTime.utc_now(), :second)

working_groups = [
  %{
    description:
      "To evolve the tools in the ecosystem related to building and deploying code, with a strong focus on interoperability between BEAM languages",
    formed: ~D[2019-04-30],
    id: "64bbc88e-5a8a-4333-b24a-15f7a4e206d2",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: nil,
      gcal_url: nil,
      github: "erlef/eef-build-and-packaging-wg",
      public_calendar: "http://127.0.0.1:9998/calendars/building_and_packaging.ics"
    },
    name: "Building and Packaging",
    charter:
      "\n## Mission Statement\nEvolve the tools in the ecosystem related to building and deploying code, with a strong focus on interoperability between BEAM languages\n\n## Main Objectives\n- Provide improved options for managing and deploying packages, and other dependencies\n- Compiling and Deploying mixed-languages projects\n\n## Benefits to the community\n- Better integration between various languages: since languages like Erlang, Elixir, LFE, or Efene all tend to be used in slightly different parts of the industry, the ability to interoperate better across all languages benefits each language individually as well, by providing more mobility and a broader pool of libraries to use, along with a more uniform experience within each language\n- The current tool ecosystem is generally understaffed within each language. By pooling resources, developer time, and focusing on interoperability, we can hope for better sustainability\n- The current tool ecosystem requires infrastructure support for builds, documentation, and other various hosting costs that are often paid for by the maintainers directly. While some tools (i.e. hex.pm) can self-sustain from commercial customers, we believe that some funding by the foundation would allow to focus on good solutions rather than just solutions that are affordable for individual maintainers.\n\n## Short term deliverables\n- Support efforts related to EEP48 (documentation chunks) integration into build tools\n- Instructions/tutorials for self-hosted hex package indexes\n- Improved usability of cross-language dependencies in projects\n\n## Long term deliverables\n- Figure out better configuration mechanisms for releases both in distillery and relx\n- Provide hermetic builds for hex packages based on auto-generated local indexes\n- Resolving issues regarding versioning conflicts between Rebar3 and mix-based packages\n- relx/rebar3 feature equivalence with reltool\n- Improved support for best practices around building and running releases for containerized environments\n\n## Why does this group require the Foundation\nWhile tooling has been self-sufficient for years, there have been recent ongoing efforts at unifying part of the infrastructure required for packages. This has forced increased levels of communication across the various sub-communities of the ecosystem, and an attempt to align efforts.\n\nMost of these turn out to be ad-hoc and done in private communication channels that lack visibility. By making these efforts public and traceable, we hope to get better results and involvement from all the involved communities, while providing more leverage when changes require involvement in other codebases, such as Erlang/OTP itself.\n\nWe also hope to be able to better align resources when it comes to providing improved accessibility, such as offering package mirrors or pre-built tool binaries, and possibly pool work towards shared libraries (i.e. hex_core, but also libraries offering portability for filesystems, and so on)\n\n## Initial list of volunteers\n- Tristan Sloughter (Rebar3, relx)\n- Wojtek Mach (Hex)\n- Fred Hebert (Rebar3)\n\n-------\n",
  slug: "building-and-packaging",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description:
      "Improve the accessibility, interoperability and quality of the documentation across projects and languages in the Erlang Ecosystem.",
    formed: ~D[2019-07-23],
    id: "8e3d6a77-1cb9-441b-8003-d0ac086d134c",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "documentation@erlef.org",
      gcal_url: nil,
      github: "erlef/documentation-wg"
    },
    name: "Documentation",
    charter:
      "\n## Mission Statement\nImprove the accessibility, interoperability and quality of the documentation across projects and languages in the Erlang\nEcosystem.\n\n## Main Objectives\n- Allow documentation to be accessed and shared across different languages in the Erlang Ecosystem (as it pertains to EEP\n48)\n- Improve the user experience in writing, generating, and reading documentation from the shell, IDEs, web pages, etc.\n- Be a central point for language designers, library authors, and tool maintainers to learn, discuss, propose, and improve\nthe current best practices related to documentation\n\n## Benefits to the community\n- Better integration between various languages: today IDE integrations written for Elixir cannot show documentation for\n Erlang projects, and vice-versa. The lack of interoperability often means developers would reimplement a library in\nlanguage X rather than use an existing library in language Y as to leverage the full toolset\n- Share tools and ideas between languages: Erlang's documentation has man pages, other languages do not. Elixir provides\n- EPUB generation and modern web front-end for documentation. By standardizing how documentation is written and accessed,\nwe write tools that work for all languages instead of fragmenting the community\n- The current documentation ecosystem is generally understaffed within each language. By pooling resources, developer\ntime, and focusing on interoperability, we can hope for better sustainability\n\n\n## Short term deliverables\n- Adopt EEP 48 on EDoc to make it interoperable with other tools in the community, such as ExDoc. Given EDoc is the most\nused documentation tool in the Erlang community, improving its outcome will push the ecosystem as a whole towards better\ndocumentation and better tools\n- Streamline generation and publishing of documentation across the existing build tools. For example, pushing a package to\n- Hex should by default push users towards also publishing docs (this requires collaboration with the Building and\nPackaging Working Group)\n\n## Long term deliverables\n- Guide languages towards adoption of EEP 48\n- Define a documentation language to be used as a standard in the community\n- Adopt said standard in Erlang/OTP and the existing tooling\n\n## Why does this group require the Foundation\nWhile EEP 48 has been a recent effort into unifying how documentation is managed in the Erlang Ecosystem, its adoption\nhas been slow. The working group will be a central point for language authors to learn about best practices and provide\nfeedback on the current standards, increasing EEP 48's adoption as well as improving the interoperability between\nlanguages.\n\nThe adoption of EEP 48 may also require changes to existing tools. Some of these tools may be managed by other Working\nGroups, which we aim to support. The Working Group may also need funding when it comes to enhancing and maintaining said\ntools.\n\nNote that it is not the goal of the Documentation Working Group to write and provide documentation for libraries and\ntools it doesn't directly maintain. Although it is our goal to provide materials and resources for library authors to\ninstruct and push them towards writing documentation of great quality.\n\n## Initial list of volunteers\n- José Valim (Elixir, ExDoc)\n- Kenneth Lundin (Erlang/OTP, EDoc)\n- Radosław Szymczyszyn (Docsh)\n- Fred Hebert (Rebar3)\n- László Bácsi (ExDoc)\n- Mariano Guerra (Efene)\n- Wojtek Mach (ExDoc)\n\n-------\n",
    slug: "documentation",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description:
      "Facilitate, evolve education and training and consolidate educational material(s) for all BEAM languages and the BEAM itself.",
    formed: ~D[2019-06-15],
    id: "a1ddc0c8-1a9e-485f-965f-3b15edab6eae",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "education@erlef.org",
      gcal_url: nil,
      github: nil
    },
    name: "Education, Training, & Adoption",
    charter:
      "\n## Mission Statement\nFacilitate, evolve education and training and consolidate educational material(s) for all BEAM languages and the BEAM itself.\n\n## Benefits to the community\n- Make an analysis of the gaps in the current state of the field so we can identify how to best help the community.\n- Create a plan and present it to the board so they can allocate resources whenever necessary.\n\n## Short term deliverables\n- Make an analysis of the gaps in the current state of the field so we can identify how to best help the community.\n- Create a plan and present it to the board so they can allocate resources whenever necessary.\n\n## Long term deliverables\n- Help grow the community by providing ramp-up materials and training to fill the gaps that have been identified.\n- Coordination work with different organizations both commercial and non-profit to foster support for BEAM technologies. Some examples are bridges, conferences, meetups & user groups.\n- Provide educational resources for corporate decision-makers who are researching Ecosystem technologies\n\n## Why does this group require the Foundation\n- A point of organization, resources, influence, and provision of funds for training and educational purposes.\n- A trusted and canonical source of educational materials and guidance.\n- Companies that are considering investing in this Ecosystem want to see a robust community, which includes active Foundation involvement\n\n## Initial list of volunteers\n- Brujo Benavides\n- Desmond Bowe\n- Laura Castro\n- Francesco Cesarini\n- Fred Hebert\n- Ben Marx\n- Anna Neyzberg\n- Bryan Paxton\n- Miriam Pena\n- Todd Resudek\n- Peer Stritzinger\n- Mrinal Wadhwa\n- Alistair Woodman\n\n-------\n",
    slug: "education",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description:
      "Standardize, improve, and promote the APIs, tooling, and infrastructure for building embedded systems and IoT devices usingErlang VMs",
    formed: ~D[2019-08-09],
    id: "73dfc610-b804-4ed7-9f5f-5a2d0a76dccf",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "embedded-systems@erlef.org",
      gcal_url: nil,
      github: nil,
      public_calendar: "http://127.0.0.1:9998/calendars/embedded.ics"
    },
    name: "Embedded Systems",
    charter:
      "\n## Mission Statement\nStandardize, improve, and promote the APIs, tooling, and infrastructure for building embedded systems and IoT devices using Erlang VMs\n\n## Benefits to the community\n- Better collaboration among the embedded systems projects in the community\n- Central location for funding of projects of common benefit to embedded systems\n- Growth of the community not only due to better software, but due to improving the\nperception of BEAM languages and the Erlang VM as mature and long-term viable platforms for embedded systems projects\n\n## Short term deliverables\nWe need to get the word out among embedded systems designers in the BEAM community that this working group exists. There\nare a lot of areas that the working group could address. A first deliverables would be to survey embedded systems\ndevelopers in the BEAM community to identify needs so that the working group can focus their efforts. Completing this\nsurvey need not delay funding of embedded systems working group stipend charters of common interest.\n\n## Long term deliverables\n\n- Standardized firmware update mechanisms and formats\n- Extensions or other means of addressing hard real-time with Erlang VMs\n- Open-source implementations for protocols commonly used in embedded systems\nproject\n- Improvements to the Erlang VM or additional libraries in support of IoT security\n\n## Why does this group require the Foundation\nThe embedded systems and IoT space is larger than any one project can address. Having a working group to align common\nconcerns across embedded projects in BEAM languages will\nincrease the quality of existing solutions and enable us to push forward in areas where we're deficient.\nAdditionally, the long life cycles of commercial embedded devices requires companies to evaluate the long-term viability\nof their software stacks. The Erlang Ecosystem and an active embedded systems working group provide this assurance for\nthe BEAM and the embedded use case in a way that can outlast the current set of individuals, companies and consultancies\ninvolved with embedded Erlang and Elixir.\n\n## Initial list of volunteers\n- Adam Lindberg\n- Frank Hunleth\n- Justin Schneck\n- Peer Stritzinger\n- Hideki Takase\n\n-------\n",
    slug: "embedded-systems",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description: "External Process Communication, Interoperability and Robustness",
    formed: ~D[2020-06-29],
    id: "d0bb4b0e-8f97-4943-bbb8-c1604a3c27ff",
    meta: %Erlef.Groups.WorkingGroup.Meta{email: "epc@erlef.org", gcal_url: nil, github: nil},
    name: "External Process Communication, Interoperability and Robustness",
    charter:
      "\n## Working Group Name\n\nExternal Process Communication, Interoperability and Robustness\n\n## Mission Statement\n\nThe mission of the working group is to facilitate and standardize interfaces and best practices for \ninteroperability with programming languages outside of languages targeting the BEAM.  We believe \nthat the efforts of the group will work towards facilitating the adoption of forward-looking \ntechnologies, promotion of the Erlang community as a good citizen in the broader technology ecosystem, \nand reduction of the barrier for adoption of BEAM-based solutions.\n\n### Background\n\nInterfacing with other languages is a common practice to harness efficiency or to provide extensibility which \ncannot be realized by the Erlang VM alone.  There are two ways to achieve interoperability:  Ports and NIFs. \nPorts are more safe and robust than NIFs due to protection by OS process segregation.  On the other hand, \nNIFs have the potential to be more efficient than Ports, especially in the context of high performance computing, \nnon-generalizable I/O systems, or bleeding edge/experimental hardware capabilities that are not ready for \ninclusion in mainline BEAM releases.\n\nSome examples of systems which require or use custom interfaces, in various stages of maturity:\n\n- Databases (e.g. PostgreSQL, MySql, Redis, SQLite)\n- Robotics (e.g. Nerves, ROS)\n- GPU compute (e.g. CUDA, OpenCL, ROCm)\n- Machine learning (e.g. Tensorflow, PyTorch)\n- Specialized networks (e.g. infiniband, virtio, RDMA)\n- New storage capabilities (e.g. persistent memory)\n- FPGA-based systems\n\nCurrently, there are several solutions created by our community that interface with other programming languages, \nbut there are not necessarily guidelines or best practices for the creation of these solutions, a process to \nreview them, or a formalized way to guide interested developers to help out with these solutions.  \n\nObjectives of the working group are to survey current strategies, to support exploration and experimentation for \nnew best practices, to craft standards for evaluating different approaches, and to help balance exploration \nwith reduction of community fragmentation and reduplicated effort. \n\n## Benefits to the community\n\n* Serve as a place to discuss potential approaches and issues;\n* Support libraries which wrap external programs or languages and have a clear direction;\n* Advertise solutions which embody best practices and help them secure users and contributors;\n* Help solutions identify points of improvement to increase their quality;\n* Help solutions be generalizable across BEAM languages;\n* Help our community coordinate to avoid reduplicated effort;\n\n## Short term deliverables\n\n* A survey of existing solutions for interoperability, and of solutions which use interoperability.\n* A survey of existing interop code maintainers to understand pain points.\n* Prototypes for systems which require custom interfaces.\n* charters for API extensions of Ports and NIFs.\n\n## Long term deliverables\n\n* Guidelines to help focus the attention and effort of new NIF and Port developers with a view towards\n  robustness, code clarity, and portability.\n* Portable generic solutions for interacting with external processes, which are potentially more efficient \n  and robust than Ports and NIFs\n\n## Why does this group require the Foundation\n\nThe topics include discussing and exploring different approaches on different platforms. To have a proper \nintegration with Erlang Runtime requires insight and guidance from the core team. This requires backing \nfrom the foundation to bring the people together. The solution has immediate and tangible benefit to the \ncommunity.\n\n## Initial list of volunteers\n\n* Susumu Yamazaki (ZACKY: a co-author of Pelemay https://github.com/zeam-vm/pelemay, nif-based computational acceleration)\n* Akash Hiremath (author of Exile https://github.com/akash-akya/exile, an alternative to ports)\n* Graham Leva (Software developer at NVIDIA, working on bringing Nerves to NVIDIA's embedded devices)\n* Isaac Yonemoto (author of Zigler https://github.com/ityonemo/zigler, interoperability with Zig language)\n* Hideki Takase (author of Cockatrice and RclEx https://github.com/tlk-emb/rclex interoperability with ROS)\n\n-------\n",
        slug: "epc",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description:
      "To formally nominate community members for a fellowship role according to the Erlang Ecosystem Foundation bylaws.  Creating and maintaining the criteria and procedure for nomination of fellows.",
    formed: ~D[2019-04-30],
    id: "30ac01f5-98fd-4328-8af7-d71f0a1a573f",
    meta: %Erlef.Groups.WorkingGroup.Meta{email: "fellows@erlef.org", gcal_url: nil, github: nil},
    name: "Fellowship",
    charter:
      "\n## Mission Statement\nFormally nominate community members for a fellowship role according to the Erlang Ecosystem Foundation bylaws.\nCreating and maintaining the criteria and procedure for nomination of fellows.\n\n## Main Objectives\n- Nominate fellows to the Foundation\n\n## Benefits to the community\n- Recognize the efforts of long term community members and participants\n- Provide the foundation with the input of said members\n\n## Short term deliverables\n- Establish requirements for a fellowship nomination as per the bylaws\n- The first round of fellows nominations for the Foundation’s first year\n\n## Long term deliverables\n- Yearly fellowship nominations\n\n## Why does this group require the Foundation\n- The group is mandated by the bylaws; the foundation needs it.\n- The group defines the criteria for an entire member category for the foundation.\n\n## Initial list of volunteers\n- Francesco Cesarini\n- Kenneth Lundin\n- Jose Valim\n- Benoit Chesneau\n\n-------\n",
    slug: "fellowship",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description: "Provide technical support and services to the BEAM community",
    formed: ~D[2019-10-31],
    id: "91b8273b-a140-40ff-bbb2-3c3840844e54",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "infra@erlef.org",
      gcal_url: nil,
      github: "erlef/infra",
      public_calendar: "https://user.fm/calendar/v1-ef278b65927fde2005be63040c195519/Infrastructure Public.ics"
    },
    name: "Infrastructure",
    charter:
      "\n## Mission Statement\nThe Erlang Ecosystem Foundation Infrastructure Working Group (Infra-WG) exists\nto provide technical support and services to the BEAM community.\n\n## Benefits to the community\n\n - Any WG approved by the Board is automatically eligible for services.\n - The Infra-WG will offer all services to all WG, but subject to resource\n constraints and other potential availability restrictions.\n - Final say in what services can be provided rests with the Board.\n - New services may be added at the discretion of the Board.\n\n## Short term deliverables\n- Provide communication infrastructure to all Working Groups including but not limited to mailing-lists,\nmail addresses and group chat.\n- Centralised file storage\n\n## Long term deliverables\n\n- DNS\n- Server and applications hosting\n- SSL certificates\n\n## Why does this group require the Foundation\nThe Infra-WG provides services to approved Erlang Ecosystem Foundation  Working Groups (WGs),\nErlang community groups, and organizations recognized by the Board of Directors (Board) as\nbeing critical to the success of the mission of the Erlang Ecosystem Foundation.\n\n## Initial list of volunteers\n- Benoit Chesneau\n- Maxim Fedorov\n- Bryan Paxton\n- Peer Stritzinger\n- Alistair Woodman\n\n-------\n",
    slug: "infra",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description: "Facilitate the reuse of software components that target the Erlang Runtime.",
    formed: ~D[2020-02-01],
    id: "b8e754bd-3b50-4d06-a9d5-ccf5f2da5a52",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "language-interop@erlef.org",
      gcal_url: nil,
      github: nil
    },
    name: "Language Interoperability ",
    charter:
      "\n## Mission Statement\nThe mission of the working group is to facilitate the reuse of software components that target the Erlang Runtime, no matter in which language they were created.\nTo reduce the friction and boilerplate required to use functionality implemented in one language from another, ideally making it look the same as if the functionality was implemented in the language being used.\nTo identify common abstractions and requirements duplicated in the languages and provide functionality in the platform to avoid duplication and incompatibilities.\nA secondary objective is to facilitate the interaction between the Erlang Ecosystem and its languages with external languages and platforms that provide complementary functionality.\n\n## Benefits to the community\n- Provide access to software components implemented in other languages that behave as close to the language being used as possible.\n- Avoid wasting effort by reimplemented functionality already available on the platform.\n- Provide visibility and unified access to functionality available in other languages.\n- Serve as a place to discuss compatibility and interoperability between languages.\n- Provide access to external languages and platforms that complement and extend the\nfunctionality of the BEAM Platform.\n- Provide functionalities that ease the implementation of programming languages on the\nplatform.\n\n## Short term deliverables\n- Erlang Enhancement charters (EEPs) for already identified interoperability areas.\n\n## Long term deliverables\n- Module Aliasing functionality to allow each language refer to modules implemented in other languages using the native naming convention.\n- User Defined Types functionality in the platform to unify representations currently implemented at the compiler level on each language.\n- Guidelines for how to design components and APIs that behave as native implementations across all languages on the BEAM.\n\n## Why does this group require the Foundation\nThe topics involve people from different communities and organizations, the changes affect languages, runtimes, the BEAM platform but also programmers of languages that use the platform.\nThese changes require backing from the foundation to bring the people together and decide on important changes that must be implemented and maintained by all actors.\n\n## Initial list of volunteers\n- Mariano Guerra\n- Robert Virding\n- Kenneth Lundin\n- José Valim\n\n-------\n",
    slug: "language-interop",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description:
      "To evolve the tools in the ecosystem related to observability, such as metrics, distributed tracing and logging, with a strong focus on interoperability between BEAM languages.",
    formed: ~D[2019-04-30],
    id: "61fd9be3-c96d-408d-b263-77c2b125a110",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: nil,
      gcal_url:
        "https://calendar.google.com/calendar?cid=N25nZ2RiNWhuZnFwODI4b2FwaTExOWprZXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ",
      github: "erlef/eef-observability-wg",
      public_calendar: "http://127.0.0.1:9998/calendars/observability.ics"
    },
    name: "Observability",
    charter:
      "\n## Mission Statement\nEvolve the tools in the ecosystem related to observability, such as metrics, distributed tracing and logging, with a strong focus on interoperability between BEAM languages.\n\n## Main Objectives\n- Improved runtime observability through integration with modern offerings -- Zipkin, Jaeger, DataDog, Prometheus, Honeycomb, LightStep, Stackdriver and many more -- without vendor lock in.\n- Improve state of whitebox monitoring of BEAM applications\n- Review possibilities to improve blackbox monitoring of BEAM (dtrace, eBPF)\n- Provide common interfaces to viewing and gathering VM and application statistics and traces\n- Cooperation with major OAM providers like New Relic to provide proper commercial support for Erlang monitoring\n\n\n## Benefits to the community\n- Provide tooling that will allow more integrated and application-wide monitoring, logging, and tracing in BEAM\n- BEAM integrating smoothly with other languages and services\n- Consolidate efforts across languages and combine tools\n- Encourage and assist library developers to make things observable\n- Encourage and make it easier for application developers to make their systems observable\n- Make it easier for users of the virtual machine to integrate it in polyglot environments where existing monitoring systems are already in place, and where lack of support is a blocker to adoption\n\n\n## Short term deliverables\n- Living document for current best practices for observability with a blog post on a prominent Erlang site like Erlang Solutions or the Foundation website to go along with it\n- Standard Logger/logger infrastructure to collect structured logs (logs, error reports and stacktraces) from both Erlang and Elixir.\n- Support for metrics and traces of popular Erlang and Elixir libraries (Hackney, Ecto, Phoenix, etc) through Telemetry and OpenCensus.\n- Support for HTTP and binary context propagation for distributed tracing in popular Erlang and Elixir libraries.\n\n\n## Long term deliverables\n- Helping library authors add standard instrumentation hooks (e.g. Telemetry or potentially even OpenCensus as it becomes more of a standard)\n\n## Why does this group require the Foundation\n- Promotion: Being a central group for user’s to find information on instrumenting and observing BEAM systems and promoting solutions to the community through the Foundation.\n- Coordination of work across languages and libraries. Bringing together the work as a central place to bring suggestions and PRs to the OTP team.\n\n## Initial list of volunteers\n- Tristan Sloughter (OpenCensus)\n- Vince Foley (New Relic)\n- Łukasz Niemier (OpenCensus)\n- Ilya Khaprov (prometheus.erl, prometheus.ex, OpenCensus)\n- Bryan Naegele\n- Greg Mefford (Spandex)\n- Arkadiusz Gil (Telemetry)\n- Zach Daniel (Spandex)\n- Mark Allen (Lager)\n- Andrew Thompson (Lager)\n- Jose Valim\n\n-------\n",
    slug: "observability",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description:
      "To expand awareness of Erlang Ecosystem and participation in its community. To promote the Erlang Ecosystem Foundation and its activities, and to increase engagement in the foundation.",
    formed: ~D[2018-10-15],
    id: "374f7386-d478-4810-9265-9efe89dac4ea",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "marketing@erlef.org",
      gcal_url: nil,
      github: nil,
      public_calendar: "http://127.0.0.1:9998/calendars/marketing.ics"
    },
    name: "Marketing",
    charter:
      "\n## Main Objectives\n- Support learning and social opportunities within the Erlang Ecosystem community\n- Gain a wider audience for Erlang Ecosystem-related technologies\n- Attract new volunteers and sponsors to the EEF\n\n## Benefits to the community\n- The BEAM community will benefit from a coordinated marketing effort of the EEF’s activities.\n- Companies and organizations choosing technologies to adopt will be more likely to choose a BEAM\ntechnology if there is a comprehensive marketing strategy.\n- Fostering excitement further encourages community growth\n\n\n## Short term deliverables\n- Increase volunteership in and sponsorship of the EEF\n- Create a brand identity, web presence, and communications infrastructure\n- Raise awareness of the EEF and its activities within the Erlang/Elixir communities\n\n## Long term deliverables\n- Expand Erlang Ecosystem adoption\n- Research health of Erlang Ecosystem\n- Promote EEF and its activities, including other Working Groups\n\n## Why does this group require the Foundation\nThe Erlang Ecosystem community needs a coordinated effort to promote its activities, both internally and externally.  Additionally, with a Working Group dedicated to raising the profile of itself and its other Working Groups, the EEF will see increased engagement and be better able to attract sponsors and volunteers.  We can also provide valuable feedback to the Foundation on the state of the community via outreach.  Support from the Foundation will enable these activities.\n\n## Initial list of volunteers\n- Desmond Bowe\n- Miriam Pena\n- Benoit Chesneau\n- Magdalena Pokorska\n- Maxim Fedorov\n- Ben Marx\n- Amos King\n- Devon Estes\n",
    slug: "marketing",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description:
      "The mission of the Security Working Group is to identify security issues, and provide solutions, develop guidance, standards, technical mechanisms and documentation.",
    formed: ~D[2019-04-30],
    id: "d03caa1f-7f93-470d-b03b-ff7d5bdf7235",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "security@erlef.org",
      gcal_url: nil,
      github: "erlef/security-wg"
    },
    name: "Security",
    charter:
      "\n## Mission Statement\nMission of the Security Working Group is to identify security issues, and provide solutions, develop guidance, standards, technical mechanisms and documentation.\n\n## Benefits to the community\n- Bringing trust in Erlang Ecosystem as a secure environment\n- Trusted source of information and discussions for entire ecosystem\n\n## Short term deliverables\n - Improve SSL implementation performance and scalability\n- Provide reference implementation for code signing\n- Ensure supply chain security for code/package repositories (e.g. hex.pm)\n- Identify, prioritize and track security issues\n\n## Long term deliverables\n- Produce and maintain secure coding guidelines and tooling for building secure applications\n- Develop hardening guidelines for BEAM deployments\n- Document security guarantees of built-in OTP applications, and improve them where necessary\n- Raise awareness of security - talks, slides, articles, blog posts, educational documents, conferences, meet-ups\n- Develop vulnerability disclosure program for the ecosystem, templates and processes for vulnerability disclosure\n\n## Why does this group require the Foundation\nSecurity resources (libraries, tools, documentation) must originate from trusted sources. By making critical resources available through the Security WG, users can be sure these have been peer-reviewed by experts in the community.\n\nSecurity features are fundamental parts of a platform, and making security-related changes requires consensus among major stakeholders. Erlang Ecosystem Foundation, and a Security Working Group being part of it, can coordinate such work and ensure consensus is reached.\n\nIt is often undesirable to disclose specific security issues before a mitigation is made. Trust in Security Working Group as a part of foundation is necessary to facilitate discussion and mitigation of sensitive issues before making a public statement.\n\n## Initial list of volunteers\n- Maxim Fedorov\n- Bram Verburg\n- Hans Nilsson\n- Peter Dimitrov\n- Griffin Byatt\n- Duncan Sparrell\n\n------------\n",
    slug: "security",
    inserted_at: now, 
    updated_at: now
  },
  %{
    description: "To approve Erlang Ecosystem Foundation Sponsor candidacy.",
    formed: ~D[2019-04-30],
    id: "5dcf7084-49b3-4477-a86b-523d13283497",
    meta: %Erlef.Groups.WorkingGroup.Meta{
      email: "sponsorship@erlef.org",
      gcal_url: nil,
      github: nil
    },
    name: "Sponsorship",
    charter:
      "\n## Mission Statement\nApprove sponsors candidacy\n\n## Main Objectives\n- Approve sponsors according to the policy defined by the board and approved by the members...\n- Encourage foundation outreach to potential sponsors...\n\n## Benefits to the community\n- Ensure that the sponsors adhere to the Foundation Values.\n- Validate the sponsorship tiers\n- Provide sponsor information to the secretary for the billing and administrative tasks\n- Provide sponsor information to the marketing group for communication purposes\n\n## Short term deliverables\n- Approve Founder sponsors\n\n## Long term deliverables\n- Approve sponsors.\n- Maintain institutional memory of outreach to potential, current and historical sponsors.\n\n## Why does this group require the Foundation\nSponsorships help the Erlang Ecosystem worldwide by supporting sprints, meetups, community events and projects,\nand of course, software development and open source projects. All of these initiatives help improve the\nErlang Ecosystem community and Erlang Ecosystem tools that are used daily. This work can’t be done without the generous\nfinancial support that sponsor organizations provide to the foundation.\n\n\n## Initial list of volunteers\n- Francesco Cesarini\n- Benoît Chesneau\n- Peer Stritzinger\n- Sebastian Strollo\n- Alistair Woodman\n- Miriam Pena\n\n-------\n",
    slug: "sponsorship",
    inserted_at: now, 
    updated_at: now
  }
]

with_html = Enum.map(working_groups, fn(wg) -> Map.put(wg, :charter_html, Earmark.as_html!(wg.charter)) end)
Erlef.Seeds.insert(Erlef.Groups.WorkingGroup, with_html)
