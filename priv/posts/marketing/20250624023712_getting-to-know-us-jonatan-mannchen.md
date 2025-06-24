{
    "title": "Getting to know - Jonatan Männchen",
    "authors": ["The Marketing Working Group"],
    "slug": "getting-to-know-jonatan-mannchen",
    "category": "marketing",
    "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
    "datetime": "2025-06-24T02:37:12.810583Z" 
}

---

# Getting to know – Jonatan Männchen

---

*Welcome to another edition in our Getting to Know Us series. Getting to know us consists of articles and interviews about a wide variety of people in our ecosystem, with the main goal of making their work with BEAM technologies visible. Some have been around a long time, while others may seem new to you, but they all share a love for this ecosystem. If you know of interesting work that deserves more visibility, let us know at marcom@erlef.org!*

<img src="/images/getting-to-know/jonatan-mannchen.jpg" class="img-fluid" alt="gtku-ajonatan-mannchen"/>

Jonatan Männchen is a seasoned developer and lead engineer, with contributions to major projects like the certified OpenID Connect client for the BEAM. He is currently the CISO of our Foundation and an active member of the Security Working Group. In his role, he helps to develop and promote best practices for security within the BEAM community. Today, we got the chance to get to know him better.

#### How did you decide to learn programming, and what were your first steps on it?

I already knew in high school that I wanted to go into programming. I am based in Switzerland, where there's an apprenticeship model, not everyone goes to university. Programming is one of the fields where you can take that path, and I quickly realized that I wanted to do that. 

I started my apprenticeship at 15, and that was really all I wanted to do. I was sure from a very young age that I wanted to go down this route.

#### What drew your interest to security and how did that evolve over time?

I think it happened gradually over time. At first, I was more interested in just building applications. I was working on different products, in consultancies, and also started getting more involved in open source.

Security was always in the back of my mind, especially because I was working on rather large Swiss services where security was really significant. Being able to handle it properly was important. So there wasn’t a specific moment when I decided, “Now I’m going into security.” It was more of a gradual shift, I just found myself getting more and more interested in the topic.

#### When did you first discover the BEAM ecosystem, and what made you decide to learn Elixir?

Around 10 years ago, I was working at a consultancy with a lot of talented developers. One of them — who later became my flatmate — somehow came across the first Phoenix book, along with another one about Elixir. I think he never actually read them, but I did, and I thought it was super cool.

Later on, when I was working at my own company, an agency I co-founded with two other partners, we came across a project that was similar to an online trivia game involving money. That meant we needed a Web Socket-based game running in the browser, but with the state managed on the server to prevent cheating.

It felt like the perfect case to use Phoenix, It was exactly what I had in mind when I first read about the technology. That project helped me realize that Elixir and the BEAM are just like any other technology. Before that, I was waiting for a kind of “unicorn project” where this technology would finally make sense. But I quickly realized that everything I used to do in PHP could be done better on the BEAM — especially in terms of system stability and testing.

#### What are some of your favorite technical highlights in Erlang/OTP, Elixir, Gleam etc. that have occurred over the past few years?

There are honestly quite a few. I really love Phoenix, even though I’m not using it as much these days. I also really like Ash. I’ve only used it once, but I appreciate the approach it takes, and I hope it gains more traction over time.

Furthermore, I think Nx is super cool. In my last job, I had to crunch a lot of numbers, and being able to throw that to a GPU was a total game changer. 

And then there are lots of smaller things too — like CLDR libraries, and others — that make the entire platform really exciting for me.

What excites you about the future of Erlang/OTP, Elixir, etc.? Is there anything you are particularly looking forward to?

I am really looking forward to the Elixir type system. I’m excited to see what kind of changes it might bring to the ecosystem, and whether it can help make our applications safer as well.

I am also quite excited about the work I’m doing currently at the EEF. It revolves around a number of security initiatives we’re trying to get started. The goal is to help bring the BEAM to a place where it works really well in environments that require strong security and strict compliance — especially within the EU — moving forward.

#### Why did you decide to join the Erlang Ecosystems Foundation?

I joined specifically because of OpenID. I was using it in a lot of projects, but I wasn’t really happy with its state. I started attending the first meetings to explore whether there was a way to implement OpenID properly on the Beam.

We actually managed to make that happen — it was a stipend project I did for the EEF. After that, I joined the Security Working Group and started contributing to various other topics as well.

You’re now EEF CISCO and also part of the EEF Security Working Group. What can you tell us about your role in both spaces?

Right now, the CISO position is more of a visionary role, I would say. I'm trying to figure out all the paths and areas we need to focus on in order to make the BEAM ecosystem viable in high-security and high-compliance environments.

Unfortunately, many of these efforts are quite complicated, they require a lot of time, which is more than I can provide at the moment. So my main focus is identifying what the most important steps are and figuring out how to secure funding so that we can actually hire more workforce to do those things.

At the same time, for the initiatives that seem feasible for me to handle with the limited time I have, I just try to push them forward myself. A good example is the OpenChain certification for Elixir that we recently released. 

#### Can you share some details about the Supply Chain Security & Compliance Initiative? What is it about, and what goals is it aiming to achieve?

There are two primary goals at the moment. The first is supply chain security, which is basically about ensuring that what you install on your device is actually what you think it is. For example, if a package claims to come from a specific Git repository, we want to be certain that the contents of the Hex package you're downloading genuinely match that source.

And at the same time, we also want to be able to make certain attestations about the things that you are installing, like what exactly went into them, where they were built, and how they were acquired

The second goal involves compliance. This is mostly about being able to demonstrate — especially to larger corporations — that we’re following best practices, that our Git repositories are securely configured, that credentials are protected, and that we’re generally doing things right.

#### How does the implementation process work for this initiative?

We're going through multiple steps for all the things we’re planning. The first step is having a broad idea of what we're actually doing — and that's what I tried to achieve by [publishing this initiative](https://security.erlef.org/aegis/ "publishing this initiative"). 

The second step is looking for funding to be able to pay the people that we need.  That doesn’t always mean money. If a larger company with know-how in a specific area steps up and says, “We’ll take on this specific topic,” that’s just as valuable. Once we have secured that, we can start making more detailed plans.

Another important part is talking to other people. I am currently participating in working group meetings from other foundations, like the OpenSSF, to learn from what others are doing. We want to get the same check marks as everybody else. We're really trying to align our approaches with what the rest of the industry is doing.

#### Finally, why would you encourage others to join the Erlang Ecosystem Foundation?

The Foundation has many [Working Groups](https://erlef.org/wg/ "Working Groups") about different topics. If you have the skills to help in any of them, it would be great to have you on board. We have Working Groups for education, embedded systems, security, sponsorship—there are lots of areas where you could help us. 

By joining, you also gain access to a lot of very interesting people who are trying to achieve the same things you are. It’s incredibly useful, for example, to be able to reach out to people like José Valim, the Hex maintainers, or others directly—whatever your area of interest—because you’re part of a broader initiative. 

On the other hand, if you’re considering joining the EEF as a sponsor, that would be great as well. As you can see we're working on a number of important initiatives, not only in security, and having more sponsors helps us financially, to fund more stipends, but also to show that the industry supports what we’re doing. 

Watch the interview on our [YouTube Channel](https://www.youtube.com/@TheErlef "YouTube Channel").

*We're eager to hear your stories, please share them at marcom@erlef.org!*


