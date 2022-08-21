{
  "title": "Getting to know - Tristan Sloughter",
  "authors": ["The Marketing Working Group"],
  "slug": "getting-to-know-tristan-sloughter",
  "category": "marketing",
  "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
  "datetime": "2022-08-21T14:48:19.825190Z"
}
---
Getting to know to Tristan Sloughter
---


<img src="/images/getting-to-know/tsloughter.png" width="100%" height="auto" alt="Tristan Sloughter"/>

<br/>
<br/>

*Welcome to another edition in our **getting to know us** series.
Getting to know us consists of articles and interviews about a wide
variety of people in our ecosystem, with the main goal of making their
work with BEAM technologies visible. Some have been around a long time,
while others may seem new to you, but they all share a love for this
ecosystem. If you know of interesting work that deserves more
visibility, let us know at <marcom@erlef.org>!*

[Tristan Sloughter](https://github.com/tsloughter) is a long time Erlang programmer and member of the Erlang Ecosystem Foundation.
While he was working at Heroku, he teamed up with [Fred Hebert](https://ferd.ca/) to build rebar3 and relx, tools for Erlang development and packaging.
Nowaday he works on OpenTelemetry at Splunk. He has given great contributions to the BEAM and today we get to know him.

**Tell us about yourself, why did you choose to be a programmer and why Erlang?**

I was able to get a somewhat early start as a programmer because my dad is a mathematician who runs Linux and programs. Growing up we had computers and the Internet since elementary school and I began toying with Linux and programming in middle school. So it has sort of just been what I have always done.

I got into Erlang just by chance while I was studying at the Illinois Institute of Technology. My roommate and I were looking for languages to learn that would be useful for us in the future. It was 2003/2004 and we wanted something that was functional, concurrent and distributed. That narrowed it down to Erlang or Mozart/Oz.

During this time, we met [Eric Merritt](https://github.com/ericbmerritt) and [Martin Logan](https://github.com/martinjlogan), who were working on the book  “Erlang and OTP in Action”. That opened more doors, we organized ErlangCamp where we taught Erlang in a two day course. After that I got my first job after leaving the PhD program at IIT at Orbitz with Martin, before leaving for a startup using Erlang, which Eric ended up joining later as well.


**What can you tell us about your Erlang/OTP learning process? Is there anything that sold you on even more after you
got started?**

As I mentioned earlier what first sold me on Erlang was the concurrency and distributed nature. But later, when I was working in production, what really got me was the ability to interact live with a running system.


**What are some of your favorite technical highlights in Erlang/OTP that have occurred over the past few years?**

I am sure it is the answer everyone gives at the moment but I think it is the JIT. This is definitely the highlight of the last year, and it is one of the biggest of the BEAM probably since they added SMP support back in like R11.


**You have made great contributions to the ecosystem, such as rebar3/relx, OpenTelemetry, grpcbox and Erleans. Can you
tell more about them, and in what stage are they now?**

When I started learning Erlang from Eric Merritt and Martin Logan they were working on the Erlang build tool [sinan](https://github.com/ericbmerritt/sinan) and package manager [faxien](https://github.com/erlware-deprecated/faxien). So my introduction and first contributions to build tools started with those. Not long after that rebar was released by Dave Smith from [Basho](https://github.com/basho/rebar) as a build tool. It was far easier to install and use than sinan, and it quickly became the de facto standard used by Erlang projects. But, unlike sinan, its release building relied on reltool in OTP, which was never really completed. So  Eric took his build tool sinan, pulled out the part that builds releases and turned it into relx, which was a stand-alone escript, just like rebar was.

I was working at Heroku at that time and Fred Hebert joined. One of the issues with onboarding people who wanted to give Erlang and our team a try in the company, was the build tools. At the end of this time, rebar was considered done and Fred and I took over to maintain it. It was not going to be possible to make the changes we thought were needed on top of rebar and to be backwards compatible. We decided the best solution was a new tool that was, in many ways, backwards compatible as much as we could be. So, one of the goals was to be more user-friendly for people joining the team or being new at Erlang. When we started, we wanted to keep as much of the good, because rebar set the standard in Erlang for build tools and it was a really huge improvement when it came around, but to remove the quirks, like dependency upgrade ordering.

Regarding the current state of rebar3 and relx, there is always work to be done. Recently, Fred reworked the compilation to be a lot faster. Now he is working on vendoring dependencies – both rebar3 itself and for projects it builds – which is something asked for by corporate users needing to build in environments without Internet access.

OpenTelemetry, which my work at Splunk is focused on, is still under heavy development, both the specification and the Erlang/Elixir implementation and instrumentations, and looking for contributors. The Erlang implementation of the tracing spec is complete but metrics is in the very early stages. I hope to have a first iteration of metrics support this year. After metrics there are still logs and the upcoming profiling spec to work on. I hope to work on [grpcbox](https://github.com/tsloughter/grpcbox) more in the future since the OpenTelemetry exporter relies on it, right now it works but could use a lot of love.

[Erleans](https://github.com/erleans/erleans) is a project to bring the ideas of Microsoft Orleans to BEAM. It is not used in production but I believe it, or at least the ideas from Orleans, have a place in any story to improve building distributed applications on BEAM and dynamic environments like Kubernetes.

**What excites you about the future of Erlang/OTP and Elixir Ecosystems and in which direction do you think it's
important to explore?**

For BEAM in general I think an important direction to explore is distributed frameworks like Orleans. Distributed Erlang has seen a number of important improvements recently, like fragmenting large messages and preventing overlapping partitions, but so much is left to the developer to get right when developing a distributed application in an environment where nodes and network connections are constantly coming and going.


I think the future of Elixir is certainly in the web but surprisingly, to me at least, may also be in [Machine Learning](https://github.com/elixir-nx/nx). And the embedded projects look really interesting and continue to grow, whether it is the [GRiSP board](https://www.grisp.org) , [Nerves](https://www.nerves-project.org) or [AtomVM](https://github.com/atomvm/AtomVM), a port of the VM to run on ESP32 microcontrollers, which I haven’t tried but really want to.

**Why did you decide to join the Erlang Ecosystem Foundation, and what do you like about working with the community?**

I was really happy that the foundation was created because I wanted it to be a vehicle for bringing Erlang and Elixir devs together. There has been a lot of fragmentation and duplicate work.

Working in the [Build and Packaging Working Group](https://erlef.org/wg/build-and-packaging) to bring together those working on mix, rebar3, hex, erlc and gleam has been very beneficial. In the [Observability Working Group](https://erlef.org/wg/observability) we converted the [telemetry](https://github.com/beam-telemetry/telemetry) library to Erlang so it could be shared between ecosystems and it is where we do some of the coordinating on instrumenting Elixir libraries for tracing with OpenTelemetry.

*We're eager to hear your stories, please share them
at <marcom@erlef.org>!*
