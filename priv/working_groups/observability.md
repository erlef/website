{
  "description": "To evolve the tools in the ecosystem related to observability, such as metrics, distributed tracing and logging, with a strong focus on interoperability between BEAM languages.",
  "email": null,
  "formed": "2019-04-30",
  "gcal_url": "https://calendar.google.com/calendar?cid=N25nZ2RiNWhuZnFwODI4b2FwaTExOWprZXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ",
  "github": "erlef/eef-observability-wg",
  "members": [
    {
      "image": "members/tristan-sloughter.jpg",
      "name": "Tristan Sloughter"
    },
    {
      "image": "members/lukasz-niemier.jpg",
      "name": "Łukasz Niemier"
    },
    {
      "image": "members/vince-foley.png",
      "name": "Vince Foley"
    },
    {
      "image": "members/ilya-khaprov.jpg",
      "name": "Ilya Khaprov"
    },
    {
      "image": "members/bryan-naegele.png",
      "name": "Bryan Naegele"
    },
    {
      "image": "members/greg-mefford.jpg",
      "name": "Greg Mefford"
    },
    {
      "image": "members/arkadiusz-gil.jpg",
      "name": "Arkadiusz Gil"
    },
    {
      "image": "members/zachary-daniel.jpg",
      "name": "Zach Daniel"
    },
    {
      "image": "members/mark-allen.jpg",
      "name": "Mark Allen"
    },
    {
      "image": "members/andrew-thompson.jpg",
      "name": "Andrew Thompson"
    },
    {
      "image": "members/jose-valim.jpg",
      "name": "José Valim"
    }
  ],
  "name": "Observability",
  "slug": "observability"
}
---
EEF Observability Working Group
---

## Mission Statement
Evolve the tools in the ecosystem related to observability, such as metrics, distributed tracing and logging, with a strong focus on interoperability between BEAM languages.

## Main Objectives
- Improved runtime observability through integration with modern offerings -- Zipkin, Jaeger, DataDog, Prometheus, Honeycomb, LightStep, Stackdriver and many more -- without vendor lock in.
- Improve state of whitebox monitoring of BEAM applications
- Review possibilities to improve blackbox monitoring of BEAM (dtrace, eBPF)
- Provide common interfaces to viewing and gathering VM and application statistics and traces
- Cooperation with major OAM providers like New Relic to provide proper commercial support for Erlang monitoring


## Benefits to the community
- Provide tooling that will allow more integrated and application-wide monitoring, logging, and tracing in BEAM
- BEAM integrating smoothly with other languages and services
- Consolidate efforts across languages and combine tools
- Encourage and assist library developers to make things observable
- Encourage and make it easier for application developers to make their systems observable
- Make it easier for users of the virtual machine to integrate it in polyglot environments where existing monitoring systems are already in place, and where lack of support is a blocker to adoption


## Short term deliverables
- Living document for current best practices for observability with a blog post on a prominent Erlang site like Erlang Solutions or the Foundation website to go along with it
- Standard Logger/logger infrastructure to collect structured logs (logs, error reports and stacktraces) from both Erlang and Elixir.
- Support for metrics and traces of popular Erlang and Elixir libraries (Hackney, Ecto, Phoenix, etc) through Telemetry and OpenCensus.
- Support for HTTP and binary context propagation for distributed tracing in popular Erlang and Elixir libraries.


## Long term deliverables
- Helping library authors add standard instrumentation hooks (e.g. Telemetry or potentially even OpenCensus as it becomes more of a standard)

## Why does this group require the Foundation
- Promotion: Being a central group for user’s to find information on instrumenting and observing BEAM systems and promoting solutions to the community through the Foundation.
- Coordination of work across languages and libraries. Bringing together the work as a central place to bring suggestions and PRs to the OTP team.

## Initial list of volunteers
- Tristan Sloughter (OpenCensus)
- Vince Foley (New Relic)
- Łukasz Niemier (OpenCensus)
- Ilya Khaprov (prometheus.erl, prometheus.ex, OpenCensus)
- Bryan Naegele
- Greg Mefford (Spandex)
- Arkadiusz Gil (Telemetry)
- Zach Daniel (Spandex)
- Mark Allen (Lager)
- Andrew Thompson (Lager)
- Jose Valim

-------
