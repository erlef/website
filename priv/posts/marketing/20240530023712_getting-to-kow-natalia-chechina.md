{
    "title": "Getting to know - Natalia Chechina",
    "authors": ["The Marketing Working Group"],
    "slug": "getting-to-know-natalia-chechina",
    "category": "marketing",
    "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
    "datetime": "2024-06-01T02:37:12.810583Z"

}

---
Getting to know to Natalia Chechina
---

#  Getting to know - Natalia Chechina

*Welcome to another edition in our Getting to Know Us series. Getting to know us consists of articles and interviews about a wide variety of people in our ecosystem, with the main goal of making their work with BEAM technologies visible. Some have been around a long time, while others may seem new to you, but they all share a love for this ecosystem. If you know of interesting work that deserves more visibility, let us know at marcom@erlef.org!*

<img src="/images/getting-to-know/natalia-chechina.png" class="img-fluid" alt="Natalia-Chechina"/>

Natalia Chechina is a developer at Erlang Solutions specializing in fintech.  Her research interests include distributed computation, robotics, parallel programming, stochastic modeling, and autonomous systems. She was the chair of the Steering Committee at Erlang Workshop in 2021–2023 and serves as an industrial supervisor, providing valuable guidance and insights to students working on Msc and PhD projects.  She is also a chair of the Embedded Working Group of our foundation. Today we get to know her.


#### How did you decide to learn programming and what were your first steps on it?

Programming was a practical choice for me. I was really good at math in school. While I was participating in all sorts of competitions, including international ones, I faced the question of what path to pursue. Initially, I wanted to be a pure math engineer, but since there were not many appealing job opportunities I could see at that age and environment I decided to go for programming – it’s really close to math, so it was relatively easy to learn.


#### When did you meet the BEAM ecosystem and how did you decide to learn Erlang and Elixir?

I had just finished my PhD when my supervisor (Prof Phil Trinder) got funding for quite a big project called RELEASE on scaling distributed Erlang and he needed a postdoc in the project, so he suggested that I apply. I went to the interview and got the job. From there on, I started my work on scaling distributed Erlang. When I started, I didn’t know Erlang, so it was a very intense learning experience from Robert Virding, Kenneth Lundin, Joe Armstrong, Francesco Cesarini and many other amazing developers and researchers who were either involved or interested in the project. Erlang became my main programming language and still is.


#### What are some of your favorite technical highlights in Erlang/OTP, Elixir, etc. that have occurred over the past few years? 

I love how amazingly Erlang simplifies life when dealing with large scale distributed systems. During my time as a PhD student, I worked with a simulation that utilized C. I remember how cautiously I handled the simulator, fearing that any small modification could break it, leading me to spend an enormous amount of time trying to figure out the solution. Additionally, the simulator was also struggling with race conditions. However, when I moved to Erlang, things were suddenly so simple. It was just so natural and for me that was a revelation.

#### What is your experience as a researcher? What contributions have you made to the research community?

A recent one is Mnesia. I co-supervised a student from Cambridge University who worked on introducing fault-tolerance into distributed Mnesia (Hypermnesia). He presented a talk at the BEAM Conference 2023 in Berlin. Mnesia is widely used but there are lots of problems with it, in particular one of the problems is that the partition is not tolerated. There are some hacks, but they have their own problems, so his work identifies properties that we definitely want to maintain in Mnesian and explores partition-tolerance techniques that can be adopted in Mnesia with minimal changes to existing code. It is not commercially ready to use work, but we have been waiting for quite a while to start this journey. So hopefully this first step will enable other developers to see the beauty of Mnesia and be inspired to adopt similar sorts of patterns, similar libraries and use the suggested approach. 

#### How is your experience working with students? 

Usually when I co-supervise students it's a project either for their final year, a master project, or a PhD. It has to be a very strong student, because there is not much time to develop the project and within this time they also need to learn Erlang. From this perspective Erlang “selects” the best. It’s an amazing experience working with these students – they are motivated, hardworking, smart, with lots of ideas and I learn a lot from them.

#### How was your experience as Erlang Workshop organizer? Could you tell us what is it about? 

 [Erlang Workshop](https://icfp22.sigplan.org/series/erlang) is about bringing together the academia and the Industry and sharing research. I was the Steering Committee chair in 2021-2023 and a Workshop co-chair in 2015-2017. Being an Erlang Workshop co-chair involves quite a lot of work. It is particularly intense around spreading the word and encouraging submissions. At the same time, it is a nice experience, as it provides the opportunity to get familiar with the research and work that is happening in the BEAM community. 

The workshop follows a typical academic format – participants are encouraged to write and present papers. For those new to writing research papers, Erlang Workshop offers lots of support. The support can be on any level: an academic and developer can write papers together, an academic just guides the writing of the paper or a proofreading/preliminary review.

#### You are currently one of the Chairs of the [Embedded Working Group](https://erlef.org/wg/embedded) of the Foundation, how can you describe their task?

Essentially we promote Erlang into embedded systems and IoT devices, we support writing proposals (not always related to embedded systems but to the BEAM community in general) and share news related to the group in general. We encourage talks for non-BEAM conferences, like robotics, because we think that exposing Erlang to other communities is very important. Attending talks related to Embedded systems and talking about Erlang makes those communities know about us. 

#### Which are the challenges and advantages of working with Erlang and Erlang VM in embedded systems? and what are the differences working with other languages?

I will answer in relation to robotics because that's what I specialize in within Embedded systems. At the moment robotics doesn’t utilize distributed systems’ state-of-the-art to the extent that we used to in the BEAM community. So, robotics can hugely benefit from the knowledge, techniques, and approaches accumulated by the BEAM community. To me the main challenge for Erlang to be accepted as a tool by the roboticits is the communication barrier and relative nicheness of the BEAM languages. These make the entry point for developers into the robotics community very steep. The majority of people who work with robots are not developers. Their disciplines have developed tools and language to describe the abilities and limitations of robots. The problem is that the words we use in the BEAM community and the words that roboticists use are very similar, but have very different meanings. 

So it’s very difficult to communicate where problems are and how Erlang can address existing issues. Simple examples are “safety” and “fault-tolerance”. Usually, when we talk about safety it’s information protection, while roboticists mean mechanisms and guarantees to protect humans from being harmed by robotsю By fault-tolerance we usually mean an ability to recover from failures automatically; while for roboticists it’s an ability of a robot to continue with their tasks while some parts are not working. 

So, when we say that a robot has safety issues or is not fault-tolerant, roboticists assume that we are completely incompetent in the area. It takes some significant effort and stubbornness to figure out the differences and start communicating so that roboticists start listening to the ideas we want to bring to the table. Another issue is that roboticists in general are not interested in learning a new language like Erlang or Elixir. So, apart from developing an idea, we need to make sure that there is a simple API and compatibility with existing tools. This leads to a very steep entrance to the robotics community. 

#### Are there any future projects or gold that you want to share with us?

There are lots of exciting bits and bobs but I don’t think I have a gold project at the moment… I’m supporting Erlang Workshop co-chairs in organising the workshop – it’s going to be in Milan, Italy this year. So, if you happen to be in Italy/Europe in September, do consider attending the Workshop – it’s always an exciting place to be to learn about new research and ideas in Functional programming.

In the Embedded Systems WP we work on developing a bank of projects for developers and academics, so that these can be picked up when developers/academics have time and would like to work on a project that is of value to the community.

#### Why did you decide to join the Erlang Ecosystems Foundation? And why would you recommend others to do so?

I joined because I really loved the idea of learning and sharing information with people who are interested in the same things as me. I was in my own tiny bubble, but when I started joining the meetings and learning with people interested in other tools and concepts, it became really exciting. 

I think we should encourage others to join the foundation because it is a way to widen our understanding of the BEAM ecosystem, learn about problems, solutions, and find people who have the same mindset or different ones. I always find it fascinating how much I learn by talking with, and listening to, people at the WG meetings.

It is also an opportunity to work on things. If there is an interest to develop something there are lots of levels of support. You do not have to be a really experienced developer, you just have to be interested and have time, there is a lot of experience in each Working Group, so you will easily find support. 

*We’re eager to hear your stories, please share them at marcom@erlef.org!*





