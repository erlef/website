{
  "title": "Getting to know - Bram Verburg",
  "authors": ["The Marketing Working Group"],
  "slug": "getting-to-know-bram-verburg",
  "category": "marketing",
  "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
  "datetime": "2023-03-16T02:37:12.810583Z"
}
---
Getting to know to Bram Verburg
---


<img src="/images/getting-to-know/bram-verburg.png" width="100%" height="auto" alt="Bram Verburg"/>

<br/>
<br/>

*Welcome to another edition in our **getting to know us** series.
Getting to know us consists of articles and interviews about a wide
variety of people in our ecosystem, with the main goal of making their
work with BEAM technologies visible. Some have been around a long time,
while others may seem new to you, but they all share a love for this
ecosystem. If you know of interesting work that deserves more
visibility, let us know at <marcom@erlef.org>!*

Bram Verburg is a developer, architect and security advocate. He has been using Erlang/Elixir coding since 2010. He is one of the founding members of the Security Working Group of our Foundation. His years of study have meant great contributions to the Elixir and Erlang communities, especially in regards to software security. Today we get to know him.

I was never really trained or hired as a programmer, it was always a side thing. I was a support engineer, a System architect or a Product manager. But in all sorts of jobs I always liked to build tools of my own, sometimes just to make my life easier, sometimes to try out APIs or do a quick proof of concept or something. I used to do that in Perl and later in Ruby.

For work, I used a little bit of Java, Scala or C, but if it was up to me, I would use a language that I enjoy doing. For a long time, that was Ruby but at some point I got frustrated and luckily I encountered Erlang.

**When did you meet the BEAM ecosystem and how did you decide to learn Erlang / Elixir?**

It was a little bit before Elixir came out. I worked in Telecom for a long time and one of the things I did there was to look up the “Erlang A and B” formulas. Erlang was a Danish mathematician who came up with some formulas for traffic engineering. But then, the first to hit Google was Erlang, the programming language. I always overlooked it and went to the Erlang formulas, until at some point I became frustrated with Ruby mostly because applications became more concurrent. I was writing the tools that had to stay up and running for a long time without failing when I remembered the earlier Google searches, and I thought I should really check it out.  So I bought the books: Programming Erlang: Software for a Concurrent World and Erlang Programming: A Concurrent Approach to Software Development.

I started playing and I got so excited because it was completely different, the actor-based programming and all the support that you get from the virtual machine, basically things you do not have to worry about. You do not have to re-implement yourself, there is resiliency -what happens if something fails and how do you recover-, it even gives you a very good starting point for clean architectures. There is a natural way to organize things in the BEAM. I got really excited about it, mostly for personal use, it was fun to explore and try out new things.

Then Elixir came out, José had been working on it for a while. I think 0.5 was the first version that was publicly announced and I also started to play with it. Over time I started to enjoy the language tools, the thought that went into Mix, Hex and ExUnit, and I ended up doing more Elixir than Erlang. That is what I now do for a living.

**What are some of your favorite technical highlights in Erlang/OTP, Elixir, etc. that have occurred over the past few
years?**

I would say, the process isolation. Today applications deal with handling the requests from many different users and the fact that you can reach them in isolation and not really worry about knowing what anyone else might be doing on the system, is great. And if something fails, this particular user is going to be seeing an error, but in most cases, that will not affect the rest of the system.

It is not just error isolation, but also performance wise, you can go a long way with the really simple Erlang or Elixir application serving hundreds or thousands of concurrent requests. At some point, your application will start to use a lot of CPU and it might get a bit slower. But it has to get close to 100% CPU utilization before users will start to notice anything, unlike in other languages where you really have to start tuning things early on to make sure that requests do not get queued up. That frees your mind in terms of how you go about developing these projects because you do not have to worry about a lot of those things. It is really a toolbox for building concurrent resilient applications. If you want to do that in any other language, you basically have to bring some of those tools in, such as libraries. In each environment you have a different set of tools to do that. But the BEAM is very consistent, you are basically ready to start to build something big and stable.

**You are currently a member of the Security Working Group of the Foundation. How can you describe their task?**

We are a bunch of people who are interested in the topic of security when it comes to the Beam. We get together and we talk about areas where we think there is room for improvement, often that is documentation or tooling. Sometimes it refers to specific features for Erlang or Phoenix or other packages, but sometimes it is just a lack of a certain package that we identified that does not exist in the ecosystem and it should exist. We see if there is some way we can move this forward. It is difficult to take on big projects, we can not start to develop tools or libraries ourselves in the Working Group. But we can talk about it, identify the need and also reach out to some people in the community or academics to see if we can get this going and if we can help somehow.

Where we do produce our own output is documentation. Early on we started the document called [Secure Coding and Deployment Hardening Guidelines](https://security.erlef.org/secure_coding_and_deployment_hardening/), because we saw a gap there, it was difficult to find information about secure coding practices. In other languages you often do a security training as part of a corporate program, and there might be some standard library functions that you should avoid and others that use instead. For C or for Java this documentation exists, and it is very commonly referred to in security training. But in our case, there was not really anything like that out there, there were only a few blog posts. We wanted to have a single place where people could go. This was a document we introduced a couple years ago. I even went to Code Beam in San Francisco and talked about it.

We are now looking at expanding this, with a new document that looks at the web specifically because there is obviously a lot of security aspects around web applications and it would be nice to have a similar document where you can go to and understand what is this all about, how to deal with cross-site scripting (XSS) in the context of a Phoenix application, what is CSRF and how does Plug handle that, for example.

**Which are the main aspects to take into account when thinking about security in software made with BEAM languages? Are
there any differences, in terms of security, with software created with other languages?**

The community is much smaller than Java or .Net, so in some of those other ecosystems there is a lot of documentation, tooling and Commercial Services that can help you. If you are a Java programmer, especially at a large enterprise, you will probably get all the stuff handed to you as part of your job and everything supposedly is secure.

In the BEAM ecosystem the availability of those tools and documents is much more limited and that can be a challenge also for compliance reasons. For example, if you are trying to introduce the language into a large enterprise or if you are trying to sell a product that is written in Erlang and Elixir to an external company that has requirements and the statements you have to fill out, and it can be tricky. They tell you that you have to run static analysis. And yes, I run Credo that is  basically a linter, it can flag certain security issues. But that is not sufficient, it does not do data flow analysis, it can not tell me that a certain SQL statement, that is being sent to the database, is susceptible to an injection attack because somewhere, in a completely different module, some input parameter from the user is passed through three different modules into that SQL statement.

That kind of tooling does not really exist for the BEAM and that can be challenging. There are some other aspects, for example, if you hire someone to do penetration testing and they are doing black box testing (testing from the outside) that does not really matter. But if they are doing white box testing, they may not understand the code base, because they may not have the necessary expertise to go through these languages or understand the way the runtime needs to be protected. Those are some of the challenges.

There are also some good things, for example, the resilience is a great feature because it helps in preventing denial service attacks. It makes the application more resilient and therefore, a bad actor will have a harder time bringing down the entire application. There are some other characteristics like the memory management feature, for example.  It does not suffer from the issues that I have seen as manual memory management when I was using pointers. If you make a mistake with a pointer, you can have a buffer overflow or a null pointer dereference. You will not have those in any language with automatic memory management like the Beam.

I also think that for example the Phoenix and Ecto, are doing a lot of things right, out of the box, and also Hex as a package manager. You can tell that the people behind those projects have taken the lessons learned in previous ecosystems and built all the necessary protections from the start. Sometimes, when people develop new frameworks, they introduce new vulnerabilities all over again that previously existed in the old frameworks. Especially in JavaScript, every month there is a new framework and people often introduce the same issues that the previous framework fixed, and then you get into this circle introducing the same issues over and over again. So I think there is some credit due to the developers of Phoenix, Ecto, Hex and also their Erlang libraries, that they built on to do things right from the very first version that came out.

**Why did you decide to join the Erlang Ecosystem Foundation, and what do you like about working with the community?**

Like I said, we are a small community and that means that we do not get everything handed to us on a plate. We need to get together and be smart about how we use our resources. We can not afford the luxury of waiting for some commercial vendors to step in and give us the tools. We can not have a handful of people each one starting a competing project to solve a certain problem and none of them gaining sufficient traction. I think the whole ecosystem can benefit from some collaboration and to actually work on the things that matter and address the main points that might exist. That means coming together and organizing: some of this stuff really needs to be in Erlang OTP itself,  some of the stuff needs to be done in a way that can benefit all the languages. That sometimes means that a library that is originally written in Elixir, maybe should be written in Erlang to make it more accessible for people who are not using Elixir.

 And also tools and documentation, which is what we spend a lot of time on in the Security Working Group, can also benefit the entire community. So when the Foundation was created I saw that there was no security working group originally. I reached out to Francesco, and I found out that Maxim from WhatsApp had exactly the same idea. So we got together and that is how we started the Security Working Group. There are other groups that are talking specifically about interoperability between languages, other about Marketing. I think it is important to make sure that we get together and move this forward, because we can all benefit from each other's experience. There are some people who have been using Erlang for 20 years and have a lot of experience, there are some people that are coming in brand new on, maybe the Elixir side, and they might not have that same background, but they might bring other experiences or just resources to the mix. If we can use all these various resources efficiently, I think everyone would benefit.


*We're eager to hear your stories, please share them
at <marcom@erlef.org>!*
