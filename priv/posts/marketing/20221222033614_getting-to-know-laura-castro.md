{
  "title": "Getting to know - Laura Castro",
  "authors": ["The Marketing Working Group"],
  "slug": "getting-to-know-laura-castro",
  "category": "marketing",
  "tags": ["developer", "marketing", "getting-to-know-us", "bio"],
  "datetime": "2022-12-22T03:36:14.938648Z"
}
---
Getting to know to Laura Castro
---


<img src="/images/getting-to-know/laura_castro.png" width="100%" height="auto" alt="Laura Castro"/>

<br/>
<br/>

*Welcome to another edition in our **getting to know us** series.
Getting to know us consists of articles and interviews about a wide
variety of people in our ecosystem, with the main goal of making their
work with BEAM technologies visible. Some have been around a long time,
while others may seem new to you, but they all share a love for this
ecosystem. If you know of interesting work that deserves more
visibility, let us know at <marcom@erlef.org>!*

Laura Castro is a professor at Universidade da Coruña (UDC) and a senior researcher at CITIC (ICT Research Centre). At
UDC she is also a member of CEXEF (Gender and Feminist Studies Centre). As part of the BEAM community, her research
focuses on software testing (automated, model, and property-based testing), applied to software in general, and
distributed, concurrent, functional systems in particular. She shares her knowledge and enthusiasm with her students and
the entire community. Today we get to know her.

**How did you decide to learn programming and what were your first steps on it?**

My first programming language or programming experience was at a small subject that we had in high school. I am not sure
how it fitted into the curriculum, but there were a few options like the math lab, the music lab, and so on, for us to
choose from. I chose the computer programming class. We had a few of those green monochrome monitors. We got to program
a little bit in BASIC and we did a program to sell tickets for concerts. It was fun figuring it out and then seeing that
the machine was doing what you told it to do. I like that was my first contact with computers, because at the time it
was not a common activity. I was from a low/middle class family, so we didn't have any computers at home and even after
that first experience, it took a while for my family to be able to afford one. But thanks to that course, it was like a
little worm was planted inside my brain, and years later it came out as an option to pursue for my future.

**When did you meet the BEAM ecosystem and how did you decide to learn Erlang-Elixir?**

That was much later on, when I was in my third year of college. At that time, we had a five-year degree for Computer
Engineering (that is how we usually name it here in Spain, and we refer with it to a mixture of what elsewhere is
referred to as Computer Science and Software Engineering). In the first and second year, we had lots of math, different
programming courses, databases, etc. Therefore,  I learned tons of languages in those two first years. And then, in the
third year, we had the opportunity to start picking our own non-compulsory subjects. I chose one that was called
“Functional Programming”.

We learned Caml, and a little bit of Haskell, and then it was the turn of Erlang. I was fascinated because I remember
that in the second year, I struggled quite a bit with C, pointers, threads, communicating threads, using mutexes and
whatnot. And all of a sudden, I had this wonderful Virtual Machine that made it all so much easier. I could have a
handful of processes, and communicating was so natural and so error-free that, for me, it was a revolution in my mind. I
thought, “this can actually be done in a much more human-friendly way, I can focus on what I want to do and not in
making it work!”

**Paraphrasing one of your talks on Code BEAM, how the BEAM will change your mind?**

As part of the functional/declarative paradigm, it changes your mind a lot, since you have to think in terms of
functions, and how you progress towards your goal without side effects. I think that nowadays, most people still have
their first contact with programming in the imperative setting, maybe in the object-oriented setting. And that also
shapes how you think in a lot of ways for the first time, ways that later on you have to change to make the most out of
the properties of the declarative or functional languages. Only in the BEAM you add on top of that the power of
lightweight processes and so-easy concurrency. As a teacher, I enjoy a lot, every year, when I get to the point in the
course where I tell my students: “Okay, now you have everything [i.e your processes] in one node. Let’s see how we move
from that to having a number of nodes (in your own machine or on different machines), and how we are going to
communicate [those processes]?” And after seeing how little-to-nothing it changes, I see their faces and I recognize my
own face when I was their age, mind-blown. “How can this be so easy in this platform and so difficult in every other
platform?” It helps me to remove lots of issues from their plate. I do not want them to struggle with mutual exclusions,
semaphores, and the like. I want them to build distributed systems and in that, Erlang and The BEAM have no competitors.
Objectively, it is the best tool for distributed systems nowadays.

**As a teacher, what advice can you give for those who are taking their first steps in the BEAM languages?**

The answer is different if the person has programming experience or not. If you already know how to program, you have to
force yourself not to repeat the things that you already know. I see that in the students.

For instance, it takes a while to remember not to use "if", if a simple pattern-matching can express the same, or not
to use some kind of loop if recursion is going to do the job more idiomatically. It takes a while to think of
functionality as functions and not as methods, that are like black boxes. It takes a while getting part of the
organization of the code to a more visible level, in the sense that you can have a function that is defined in a few
blocks and not just one block structured with “if” or “case” or something like that; that change is difficult, the more,
the longer experience one has in other paradigms. I would also say that you should take advantage of the flavour
that appeals most to you, because we have lots of flavours to interact with the BEAM. So if you're
a Haskell person, or you are a Ruby person, there will be something that appeals more to you. It will be something
that is syntactically closer to you, and it will allow you to explore the BEAM and to exploit its powerful abilities.

For someone who will be so lucky to approach The BEAM with no prior experience, I would say “Enjoy!” It is really
powerful what you are going to be able to accomplish with this platform and languages in a very few sessions.

**How are thoughts on testing in the development process and what are the differences between testing in
BEAM Languages and other languages?**

Testing should be a natural part of the development process. I think we made a big mistake in the software development
world, back in the day, when [methodology-wise] we split that from the implementation. Because it led to many projects
delaying tests or to not regard tests as highly as other development tasks, and that has consequences.

I think that this trend is being reversed, people acknowledge the usefulness of tests and that they are valuable work,
and intellectually challenging. It is not only about writing something that will pass. It is about finding ways of
exercising my project, my system, my components, so that I have confidence that I have done a good job and there are as
fewer uncovered edges as possible. As far as the testing in the BEAM is concerned, I think we were lucky that we were
part of the functional family, because we got to be one of the first to import the idea of property-based testing right
after the Haskell community. We were lucky enough to have John Hughes close to our community and being part of that
idea.

Nowadays, almost everyone [Java, C…] has their property-based testing tool, which for me, is one of the best compromises
between more formal ways of testing and the kind of testing that we call example-based (i.e. eUnit, JUnit, cUnit, etc.).

Writing tests is important because it is difficult to do it right, and it is very easy to do some trivial testing that
will not really benefit you. Somehow, I think property-based testing sits in the middle: it gives you a lot of power, it
forces you not to think of examples out of your already-existing implementation, but to think at higher level, to think
of properties, and also then you get for free hundreds or thousands of tests.

I think it is a great tool and we were lucky to be close enough to the origin. We have a number of implementations of
this property-based testing technique, and we are probably one of the development communities that are really using this
property-based testing in practice, in small and large projects. That is not something that a lot of communities can
say, and it speaks of the quality of the products that are being built on top of the BEAM. Even though our motto is "let
it crash", that does not mean that we will not test it.

**In your experience, how do you see the representation of women in technology? Have there been changes in recent years
regarding academic and work schedules/fields?**

I am going to be a little bit cautious, because I can only speak from the perspective that I have lived in my closest
context: Galician, Spanish and European. Because I know there are differences in other places, for example, in India, I
know there are lots of women that are approaching careers in IT, because it provides a social benefit from them. So it
is a different reality in other parts of the world.

Having said that, the perspective is not really good in the Western World. Every time we check, there are fewer women,
and it has already been a number of years, maybe a decade or more, that there have been lots of initiatives at all
levels to try and counteract this lack of diversity. We have programming contests for girls in high school and in
elementary school, we have lots of initiatives to claim that women are so smart, they are here, they are professionals,
and they are fantastic. We expect that to solve the problem, but the problem is still there.

I am a little bit  torn, because I am always trying to get involved in programs or conferences, or whatever event to
contribute to, if that can help. Then, on the other hand, I see that the effect that we are hoping for, is not really
there. So, my personal take is that the problem is far more complex.

At UDC, we have a group called ["Hello, Sisters!"](https://hellosisters.github.io/) : it is a group for female computer
science students, teachers and women that have graduated and are already working in the industry. We do mentoring,
counselling, and mainly provide a safe space and a network of peers as contacts for personal and professional growth.
There, we also talk a lot about the difference that society sees in technology nowadays from 20 or 30 years ago. I think
that the popularization of technology did not help our profession, because when I studied, and that was 20 years ago,
most people did not really know about computers and did not know what a computer engineer was.

The difference is that now technology is everywhere. So people see and use technology every day, and they have the false
feeling of "Yeah, I know what this is. I don't want to be a part of it". It is probably preventing at least some part of
the population, namely many women, from approaching the IT world, and that goes hand-in-hand with the image that we see
on TV series and movies. When I was young, the only movie that there was with computer geeks was War Games, who was a
kid that saved the world from WWIII! But, then it came a moment where in almost every TV show or movie there is “the
geek” and it is so cliché.

With the popularization of technology came a lot of clichés around the profession that did not really benefit the
diversity in technology. I think that it is a really complex problem with lots of factors and probably the solution, if
we ever come to it, will have to address lots of things at the same time. Nowadays, I have the belief that we are only
focusing on girls and saying "Hey! Come here!", but we are not really thinking, for instance, why men do not go and do
other things.

**Are there any research projects being developed at the moment that you think deserve special mention?**

The most recent project that I have been involved in is not particularly about the BEAM, it is about using the BEAM to
give power to other people's projects. In this case, I have been working closely with people in the communication branch
of science that study how people interact and how technology has changed human communication.

It has been amazing for me, because I had never worked with people outside the IT world. Also, it is great to build
tools for them so that they can learn more about how all of us behave, who we are not addressing, who is being left
outside the so-called online conversation and what it means for society in 2022 for that to happen. I am helping people
that have never heard of the BEAM, to accomplish their projects with the help of the BEAM.

**Why did you decide to join the Erlang Ecosystem Foundation, and what do you like about working with the community?**

I am part of the Education Working Group. For me, it is great to share experiences and to think what people approaching
the BEAM for the first time can benefit from. We can produce, help to produce, or maybe just make visible what we all as
a community do in that regard. And there are still so many things to learn. Every time we have a meeting, where there
are people from all around the world, I always get ideas. It is a fantastic group of great minds that are very practical
about how to use the BEAM, in particular as a teaching tool, and with a shared passion to make it more approachable to
anyone. I feel that I have learned more than what I have given!

*We're eager to hear your stories, please share them at <marcom@erlef.org>!*
