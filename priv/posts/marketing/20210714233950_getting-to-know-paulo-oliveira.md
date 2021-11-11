{
  "title": "Getting to know - Paulo F. Oliveira",
  "authors": ["The Marketing Working Group"],
  "slug": "getting-to-know-paulo-f-oliveira",
  "category": "marketing",
  "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
  "datetime": "2021-07-14T23:39:50.502278Z"
}
---
Getting to know to Paulo F. Oliveira
---


<img src="/images/getting-to-know/poliveira.png" width="100%" height="auto" alt="Paulo F. Oliveira"/>

<br/>
<br/>

*Welcome to another edition in our **getting to know us** series.
Getting to know us consists of articles and interviews about a wide
variety of people in our ecosystem, with the main goal of making their
work with BEAM technologies visible. Some have been around a long time,
while others may seem new to you, but they all share a love for this
ecosystem. If you know of interesting work that deserves more
visibility, let us know at <marcom@erlef.org>!*

[Paulo F. Oliveira](https://github.com/paulo-ferraz-oliveira) is a Portuguese software developer and a member of the
Erlang Ecosystem Foundation. With a career spanning over 17 years, he
has worked on the most diverse projects: from mobile games backends
and internet portals, to NATO port surveillance systems and helicopter
engine software, to space projects. And today, we got to know him.

**Could you tell us a bit about yourself and your early years?**

I was born in Covilhã after my family came to Portugal from Mozambique,
and almost immediately I moved to Santo André, next to the sea, where I
lived for the first 20 years of my life.
I left Santo André to go to the University of Algarve, where I studied
Computer Systems Engineering and where I got really interested in
software development. It is also where I realized that it was not as
difficult as I thought it was. My final thesis was a parser/lexer for
Fortran targeting parallel image processing on Beowulf Clusters
(SPMDdir), for which I wrote a paper on.
I then went to work for SAP. About one and a half years later, I quit: I
became more interested in software development there but not equally
interested in the product.
I continued learning programming by myself (it was not the main focus of
my degree), mainly using Java, PHP, and MySQL. I even created a small
blog software at that time.
Then I had the opportunity to work for Opensoft, where I worked on a
logistics management system that integrated with SAP. I was developing
the portal and backend in Brazil, where I lived for 2 years.
After this, I moved back to Portugal and got into Edisoft; they do a lot
of things, mostly state-related and heavy-duty systems: systems for the
navy, for space, for geographical databases, and so on. They work with
embedded systems, so I got to learn a lot with them. During this time, I
moved to France to work for Turbomeca, where I worked in the software
department specifying and testing software. Two years later, I got
involved in the development of said software and stayed in Portugal for
3 months until a new opportunity came up to work again in France for the
same people, but at a higher level: I would continue specifying and
testing systems but also developing software. This is where I got into
contact with "esoteric" languages like DXL, and systems like
ClearQuest. In 2008, the economic crisis struck, Edisoft was basically
forced to give up the project and I came back to Portugal, to the
headquarters, where I started working in the development of a complex
port surveillance system.
After a while, they proposed that I move to the space department, where I
did software in C for embedded software for satellites, with a system
called RTEMS.

**How did you end up working with BEAM technologies?**

After leaving Edisoft, I started working in a company that developed a
product for real-time communications using WebSockets, and this is where
I got my first experience with high scalability systems and millions of
concurrent connections: they were building a system that was similar to
Erlang+WebSockets, and this was the first time I heard about this
language. I was even told that if you spend enough time working around a
system that needs fault tolerance, scalability, and high concurrency, you
will eventually build your own version of Erlang. And this is what I
feel they ended up doing, only from scratch.
A while after, I got requested for an interview with Miniclip to which I
initially said no because ---confesses a little embarrassed--- I didn't
like the syntax of Erlang and I felt too comfortable with Java. Then I
realized these kinds of things never had stopped me in the past and gave
it a shot. I got the chance to lead the backend development for Soccer
Stars initially, and later for Agar.io, both were hit games at Miniclip,
after which, still at the company, I moved to work in engineering-first
teams.
In 2017, I got to attend the Erlang User Conference, in Stockholm,
and I ended up getting even more involved with Erlang (that conference
was a pivotal moment for me). I got to meet Joe Armstrong, Robert
Virding, Francesco Cesarini and all the "big" guys. At the time, I
knew nobody else from the community, apart from those whose books I had
read. I was very happy to be part of it, and I gradually got more in
contact with the community and contributing to open source, which I
now do regularly even for the EEF maintained repositories.

**Is there anything in Erlang/OTP that sold you even more after you got
started?**

Most things sold me. For example, pattern matching. I was working
heavily with JavaScript before, and even though it's a multi-paradigm
language, and you can have functional, you don't have pattern matching,
and that's a huge part of Erlang.
It took me quite a while to understand two things properly: the first
being what the "let it crash" philosophy meant. And the second one,
which is very attached to the first one, was error handling. If there
are errors and you know that they will occur, you better handle them,
but do it in the right context; if you can't handle them, don't worry,
although when we say let it crash, we don't mean "let the application
die", rather we're referring to processes that run in the app. Used
correctly in Erlang, error handling is something that I love to explore
and keep fostering.
The first piece of software that I wrote for Erlang was not useful
software, it was just a basic test: I wanted to see how amazed I would
be about this lightweight process mechanism everybody was always talking
about. I wrote a very simple script that launched a million processes,
and they all died after doing nothing. And it ran really ---really---
fast, without using many resources. I tried to do the same with Java,
and it was super slow: concurrency is a big part of what I love, but I
also love performance, and Erlang gives me that.
As a CI and static analysis aficionado, one other thing I have to
mention that was really nice to find out-of-the-box was dialyzer. I
absolutely use it always.

**Are you learning something new at the moment?**

I started learning Elixir a few months ago for two main reasons: the
first one is that it is not very easy to recruit Erlang-first developers,
so we're looking into Elixir developers to be able to have a broader
search scope. Also, there are some things about Erlang that I would like
to see improved, out-of-the-box, like documentation and formatting, and
Elixir gives us those.
The second one is to not get tied to a single language. There is a big
community around Elixir that I want to explore if possible. It is also
very interesting to see the similarities between Erlang and Elixir
communities and the way they interact.
I'm also learning of some of the difficulties of adopting OTP 24
because in this shared technology stack that my team does, one of the
goals is to keep on top of the latest technologies.

**What else do you like about working communally?**

First of all, people are very welcoming, and I feel that it's good to
be there. And secondly, many of them give away their free time and
energy in order to build something that they like and believe in, and
that benefits others. And this kind of interaction is unbelievably
rewarding.
I'm a regular participant in the Erlanger Slack, as well as some
projects like [elvis_core](https://github.com/inaka/elvis_core), [erlcloud](https://github.com/erlcloud/erlcloud), 
and [setup-beam](https://github.com/erlef/setup-beam).
I feel other members of the community always want to understand what's
the problem you've been trying to solve, and always want to help.
Sometimes they solve an issue for you ---or with you--- and you realize
that you wouldn't have solved it otherwise. I'm a strong believer in
the OSS development model, and I love collaboration. I like the fact
that together we can build something. Even if you're working alone in a
lab, somebody built that lab and the instruments you work with.
I try to give back as much as possible because I strongly believe that
collaboration is a two-way street, which is why I'm now organizing
[SpawnFest 2021](https://spawnfest.org/) with other members of the Erlang community: Bryan Paxton,
Pablo Costas Sánchez, and Filipe Varjão. And finally, I want to take this
opportunity to thank Brujo Benavides for all the help he gave us setting
up the initial structure for this year's SpawnFest, and together with
Bryan Paxton for getting me personally so involved in the community as I
am.

*We're eager to hear your stories, please share them
at <marcom@erlef.org>!*
