{
  "title": "Case Study: DNSimple",
  "authors": ["Sponsorship"],
  "slug": "case-study-sora-dnsimple",
  "category": "sponsorship",
  "tags": ["sponsorship", "meet-the-sponsors"],
  "datetime": "2025-12-17T03:37:12.810583Z"
}
---
This case study highlights how DNSimple uses Erlang to power a stable authoritative DNS service capable of handling hundreds of billions of queries each month. It also explores how Erlang supports their globally distributed infrastructure, enabling fast DNS response times and sub-60-second zone propagation worldwide.
---
This case study highlights how [DNSimple](https://dnsimple.com) uses Erlang to power a stable authoritative DNS service capable of handling hundreds of billions of queries each month. It also explores how Erlang supports their globally distributed infrastructure, enabling fast DNS response times and sub-60-second zone propagation worldwide.

<img src="/images/meet-the-sponsors/dnsimple-casestudy.png" class="img-fluid" alt="Case Study - DNSimple"/>

DNSimple delivers simple and secure automation for domain registration, primary DNS hosting, SSL certificates, and more — providing reliable DNS hosting and domain name management, whether you handle one domain or 100,000.

In April 2010, DNSimple founder Anthony Eden wrapped up work on a startup and found himself increasingly frustrated with the complexity and poor usability of existing domain registrars. Having been involved in the domain industry since 1999, he decided to build a service that he, as a software developer, would want to use for managing domains and DNS. By July 2010, the first version of DNSimple was launched.

#### Team and Process

DNSimple has been a fully remote and asynchronous company since day one. Work across all departments is coordinated through GitHub, supported by additional tools such as Miro when needed. Over the years, they have explored several project-management approaches and currently use the Shape Up methodology originally developed at Basecamp.

#### Technologies and Tools Used

Their primary application stack is Ruby on Rails with PostgreSQL as the main database. They originally used PowerDNS, an open source DNS server written in C++, for our authoritative DNS infrastructure. In 2013, they began developing their own open source authoritative name server, [erldns](https://github.com/dnsimple/erldns), written in Erlang. Since 2014, erldns has powered DNSimple’s production authoritative infrastructure.

They also use Go for several internal systems, including the messaging service that delivers DNS updates to their data centers and their URL redirection service.
Their Erlang name server uses [Rebar3](https://rebar3.org/) for building the system and Cowboy for certain HTTP administrative endpoints. They also rely on the [open source Telemetry library](https://opentelemetry.io/) for instrumentation and observability.

Erldns was originally based on the open-source dns_erlang project, an excellent library for serializing and deserializing DNS packets. DNSimple took over maintainership of [dns_erlang](https://github.com/dnsimple/erldns) several years into erldns’s development. The erldns project itself is open source, with proprietary components used internally within DNSimple’s umbrella service.

#### DNS infrastructure

They use a hub and spoke architecture for their DNS infrastructure. The core database publishes zone data to a zone server located in each of their data centers. Each zone server broadcasts zone updates to all local name servers through a WebSocket connection. A name server then applies the zone change or retrieves the full zone from the zone server before applying it.

Internally, erldns is an OTP application managed by a primary supervisor. This supervisor starts child supervisors for zone-change management, DNS request and response handling, and telemetry. The request and response pipeline is the core of the system. Each step in the pipeline implements a custom behavior that determines whether processing continues or stops. These steps encapsulate discrete business logic and emit telemetry, creating a clear and efficient mechanism for processing DNS queries at a large scale.

#### Overcoming Challenges

As query volume has grown significantly, they have continually identified and resolved performance bottlenecks in the system. These include raw query-processing performance, packet handoff throughput, and zone-loading optimization. DNS traffic often experiences sudden surges — both legitimate and malicious — so the system must scale reliably while meeting strict service-level commitments.

Another ongoing challenge is finding developers with Erlang expertise. The availability of experienced engineers varies over time, so they invest in internal training and, when necessary, work with external contractors to address particularly complex problems.

#### Benefits of using Erlang 

Erlang is a natural fit for DNS because of its functional design, its excellent bitstring handling for packet parsing and generation, and its well-established OTP patterns. The resulting DNS-processing code is fast, concise, and easy to read — essential for a system that handles billions of queries each month. Erlang’s reliability and concurrency model have played a central role in the design of DNSimple’s global DNS architecture.

*Our foundation is supported by the funding of our sponsors, and it is what allows us to carry out projects, marketing initiatives, stipends programs, and accomplish the goals that we have established as an organization. So if you are interested in becoming a sponsor, contact us at [sponsorship@erlef.org](mailto:sponsorship@erlef.org). We look forward to hearing from you!*

