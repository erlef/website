{
  "title": "Behind Elixir - An interview with José Valim",
  "authors": ["The Marketing Working Group"],
  "slug": "behind-elixir-interview-with-jose-valim",
  "category": "marketing",
  "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
  "datetime": "2022-06-08T03:04:19.165697Z"
}
---
Getting to know to José Valim
---
In order to celebrate the tenth anniversary of the Elixir, we met with its creator and member of the Erlang Ecosystem Foundation, Jose Valim, to remember how it all began, the importance of the community, and what's coming next for this language.

<img src="/images/getting-to-know/jose-valim.png" class="img-fluid" alt="Getting to know - José Valim"/>

<br/>
<br/>


**It's been ten years since the release of Elixir and we wanted to start this conversation by remembering that first search which led you to create this language. What was the starting point?**

Back in 2009, I was already thinking about concurrency and how to write elegant and robust software that runs on multiple cores.
Back then, the platform that I used was not good for concurrency, so I decided to investigate others. This is when I found Erlang, and I would like  to say that I fell in love with it. The more I learned about it, the more I could say: "This is the platform, this is the technology I want to use for the next decade". Eventually, as I learned more about it, some ideas started to popping up in my head about all the benefits of the BEAM. That is the main thing that led me to Elixir.

**What are the use cases of Elixir and the advantages that Elixir presents over other languages?**

When Elixir started, my background was in web applications and I knew that Elixir would be good at this. Especially because the platform, the Erlang Virtual Machine, is great for everything that is running on top of a socket. But I also didn't want Elixir to be a language that was going to be used only for web development, mostly because the BEAM was already useful at several levels, like TCP/UDP applications, building distributed systems, etc.

I have always intended that the language has multiple use cases and we saw that happen in the last 10 years! Nowadays, Elixir has the Phoenix Framework for web development, or Nerves to build embedded applications. We also have GenStage + Broadway for building the pipelines, and Membrane for audio/video processing. Recently, we started a new effort: bringing Elixir to the world of numerical computing and machine learning with Nx, Livebook, and Explorer.

**What is the importance of Elixir being an open-source programming language?**

We have many great features that were brought by the community. In all the releases of Elixir, somebody contributed or someone started a discussion about a feature or issue they would like to see addressed. The community is always active, contributing at different capacities.
In recent years, more programmers have been interested in Elixir. What advice would you give to junior developers that take their first steps in Elixir’s world?
The Elixir community is quite welcoming. I recommend them to join the foundation or Slack or IRC… whatever they feel more comfortable with. Plus we are now starting to have in-person events once again!
I would like to recommend them to enjoy their experience, regardless of their technical level.

**What features of Elixir are you working on right now, and what can we expect from the upcoming releases?**
We have a new Elixir release every six months. We continue bringing improvements to the language, fixing bugs, and I don't expect this to change. But, since Elixir is a stable language, I can focus most of my time working on the ecosystem. For the last year and a half, I have been working mostly on bringing Elixir to numerical computing and Machine Learning, with the tools I mentioned before (Nx, Livebook, and Explorer). One thing that is really nice about Elixir is that it is designed to be an extensible language. Anyone can bring it to new domains! It does not depend on me or anybody from the team. You should also be able to bring Elixir wherever you want!

**Why did you decide to join the Erlang Ecosystem Foundation, and what do you think is the most important aspect of this type of organization?**

Erlang is both the past and future of Elixir. Without Erlang, there would be no Elixir. If we can all get together to improve the platform and the technical foundation of the language, everybody is going to benefit from it. When I was invited to be one of the founding board members of the Foundation, it was very clear to me that it was important. Therefore I am glad to see the Elixir community having a role in it too.

*We're eager to hear your stories, please share them at [marcom@erlef.org](mailto:marcom@erlef.org)!*
