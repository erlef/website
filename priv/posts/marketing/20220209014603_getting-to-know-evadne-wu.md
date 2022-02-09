{
  "title": "Getting to know - Evadne Wu",
  "authors": ["The Marketing Working Group"],
  "slug": "getting-to-know-evadne-wu",
  "category": "marketing",
  "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
  "datetime": "2022-02-09T01:46:03.911251Z"
}
---
Getting to know Evadne Wu
---
<img src="/images/getting-to-know/evadne-wu.jpg" class="img-fluid" alt="Evadne Wu"/>

<br/>
<br/>

## About this series 

<p>
 Welcome to another edition in our getting to know us series. Getting to know us consists of articles and interviews about a wide variety of people in our ecosystem, with the main goal of making their work with BEAM technologies visible. Some have been around a long time, while others may seem new to you, but they all share a love for this ecosystem. If you know of interesting work that deserves more visibility, let us know at 
 <a href="mailto:marcom@erlef.org">marcom@erlef.org</a> !
</p>

## Getting to know Evadne Wu

Evadne Wu is a software engineer, a member of the Erlang Ecosystem Foundation, and a great contributor to the ecosystem.
She has been responsible for several projects that enriched our community and has given many talks at international conferences, such as Code BEAM and ElixirConf. And today, we get to know her.

## Tell us about yourself and why you chose to be a programmer

I have always liked to tinker and create, and software is the most malleable medium to express ideas. Therefore, I have chosen programming. 
In the past years, I have taught programming to many people and learned from many more, and I would like to continue doing the same in the future.

## What made you choose to work with BEAM technologies specifically?

My first introduction to Erlang/OTP was by word of mouth. When we experienced a concurrency problem in one of the systems that my team was developing, a fellow engineer suggested that we should take a look at Elixir and its ecosystem and see what it could offer. We ended up successfully creating the prototype with Elixir. 
Encouraged by the success, I have then started to study Elixir and Erlang/OTP in depth. It was of great help that the community was friendly and helpful and that I was able to grow with it, as Elixir gained wider acceptance around the world.


## Tell us about the most interesting project that you have participated in

This would be the project in which we were to create a system that can intelligently identify near-duplicate documents. 
Originally, we adopted the SimHash technique to deal with the problem, but the implementation was too slow and unsuitable for the purpose. Therefore, we had to write the program again, but this time in Rust, and expose the core functionality as a NIF which can be called from the Elixir side. This was an interesting learning experience for the engineers working on this project, as we haven’t had to create NIFs before and did not have knowledge of Rust.


## What are some of your favorite technical highlights in Erlang/OTP, Elixir, etc. that have occurred over the past few years?

We were pretty satisfied with what came out of the box since our first day with Elixir. However, several improvements within Erlang/OTP were quite helpful for us, especially the increased performance in Erlang/OTP 24 thanks to the introduction of a JIT compiler. Additionally, native atomics and counters were also very helpful for our use cases.

## What excites you about the future of Erlang/OTP, Elixir, etc.? Is there anything you are particularly looking forward to?

With wider adoption, ease of attaining raw compute performance will be the next flagpole feature in my opinion. This can either be achieved by allowing the developer to create sensitive functions in another language and linking them in as NIFs, or enhancing the performance of the BEAM to allow such functions to be implemented natively.

- [Elixir NX](https://github.com/elixir-nx/nx) was a notable project which demonstrated a way to achieve high-performance computation while keeping the control layer in Elixir. Granted, this paradigm was not new, but it is always good to have modern implementations of tried and true ideas.

- [LiveView](https://github.com/phoenixframework/phoenix_live_view) attracted massive adoption within the community, possibly because most of the engineers prefer this mode of abstraction. It must have something to do with the extreme churn we have seen in the JavaScript space now even Phoenix is trying to abandon Webpack. On top of this, we have seen [Phoenix LiveDashboard](https://github.com/phoenixframework/phoenix_live_dashboard) and now [Livebook](https://github.com/livebook-dev/livebook).


## Are there any projects being developed at the moment that you think to deserve special mention?

Many projects are created every day, and I love them equally. However, I would say check out the winners of [Spawnfest 2021](https://spawnfest.org/2021.html), there are some really intriguing entries.

## You have made great contributions to the ecosystem, such as Ecto and Packmatic.  If you had to describe what these projects mean to you today, what would you say?

These projects solve invisible problems that exist in established applications, which the users would otherwise live with. Only when carefully examined would these problems be noticed; these inefficiencies, then, can not be un-seen. 


- [Etso](https://github.com/evadne/etso) as created initially as an example to accompany my talk at [ElixirConf regarding ETS](https://www.youtube.com/watch?v=8mXqxBBvNdk). It has since found practical uses within many applications, including the official EEF website. With each different way the library is used, its value increases.
    - It can be very difficult to scale horizontally if the database is the bottleneck. However, in certain use cases, the data is allowed to be a little bit stale; this would be sacrificing Consistency in favor of Availability. One good example for this use case would be a [hotel room booking system](https://www.colinsteele.org/post/23103789647/against-the-grain-aws-clojure-startup), where there are numerous properties, but few bookers at any one time. In such use cases, it may be permissible to scale horizontally by refreshing the data and making copies on an hourly or daily basis, and only checking against the database in real-time, when the user is ready to make a booking.
    - Another way to utilize this ability is in application prototyping, where the developer knows that, at some point, a database will be required, but does not yet wish to start creating schemata, possibly due to the amount of work that goes into such rituals. In this scenario, Etso would be a good fit for prototyping, as the schemas can be changed quickly by the developer, and iterated upon until the developer is ready to commit. In a past entry for Spawnfest, Steven, Brandon, and I competed as the [Bodgemasters](https://spawnfest.org/2019), and created [Exile](https://github.com/spawnfest/exile), exposing NoSQL as a service. This served as the basis for my idea of creating Ecto.
- [Packmatic](https://github.com/evadne/packmatic) was, however, created during the development of another system I have created for a client, but this time out of calculated laziness. The library offers easy creation of downloadable ZIP files exposed as streams, so the user may elect to create a large archive of many objects and start downloading immediately, without having to wait for the archive to be built first.
    - The architecture of Packmatic is beneficial for me as a developer, because it simplifies state management, as otherwise, I would have to implement an asynchronous process to download the constituent parts, create the archive, hold it in temporary object storage, then email the user with a link. The user would also have to wait for the process to start.
    - With Packmatic integrated, the process is transparent to the user, and the download starts immediately. The speed of the user’s internet connection dictates how quickly the content can be prepared, and the user is subconsciously assured by the immediate reaction, that the application is responsive.
    - Without using Packmatic, the user must wait for the download link, then start the download manually. The user would not be free to progress other tasks in the meantime before the download link arrives. I would estimate that such inefficiencies exist in great abundance across applications we use daily, especially within enterprise applications.
    - With Packmatic, the download starts immediately; with the assurance of the download making progress, the user is free to handle other tasks while the download progresses. The improvement is qualitative in terms of how the user feels and quantitative in terms of the time saved.

## You were a judge at SpawnFest 2021, can you tell us what interested you in doing so?

I was asked by the organizers whether I would be interested to help them as a judge. It felt like a good learning opportunity, especially given that all BEAM languages were allowed last year.


## Why did you decide to join the Erlang Ecosystem Foundation, and what do you like about working with the community?

I was asked to join as a member and pay the annual fee to help fund projects. However, my membership has not impacted my view of the community at all. Membership in the EEF is not a prerequisite for full participation in the community, in fact, this is a very good aspect of the community.

-------------
<p>
We're eager to hear your stories, please share them at 
<a href="mailto:marcom@erlef.org">marcom@erlef.org</a> !
</p>
