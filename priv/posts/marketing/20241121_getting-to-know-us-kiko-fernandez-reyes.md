{ "title": "Getting to know - Kiko Fernandez-Reyes",
"authors": ["The Marketing Working Group"], 
"slug": "getting-to-know-kiko-fernandez-reyes", 
"category": "marketing", 
"tags": ["developer", "marketing", "getting-to-know-us", "bio"], 
"datetime": "2024-11-21T02:37:12.810583Z" }

#  Getting to know - Kiko Fernandez-Reyes

*Welcome to another edition in our Getting to Know Us series. Getting to know us consists of articles and interviews about a wide variety of people in our ecosystem, with the main goal of making their work with BEAM technologies visible. Some have been around a long time, while others may seem new to you, but they all share a love for this ecosystem. If you know of interesting work that deserves more visibility, let us know at marcom@erlef.org!*

<img src="/images/getting-to-know/kiko-fernandez-reyes.png" class="img-fluid" alt="gtku-adolfo-neto"/>

Kiko Fernandez-Reyes is a software engineer and a core member of the Erlang/OTP team. He works building and improving the Erlang programming language at Ericsson. He is also the co-chair of the Erlang Workshop for the second year in a row and a board member of our Foundation. Today we get to know him.

#### How did you decide to learn programming, and what were your first steps on it?

I was around 12–13 years old when I started playing with BASIC. At that time — of course, I didn't know — I wanted to write some kind of AI program, something that replies to you so that you can maintain a conversation. I managed to a small a degree.


Then, at the University of Malaga, I learned C/C++, but I did not like it that much. I also took a course called Declarative and Logical Programming, where I learned Haskell and Prolog. I really fell in love with Prolog, to be honest. Furthermore, I learned Ada, which was mind-blowing because of its parallel concurrency model.

#### When did you meet the BEAM ecosystem, and how did you decide to learn Erlang?

I was working on my PhD, and there was a group working with Erlang, but I was focused on my own programming language with the research group, so I did not pay much attention to it. I did not look at Erlang until after I finished my PhD and started working at Klarna.

At Klarna, they used both Erlang and Haskell. I was already familiar with Haskell from my PhD work, but not with Erlang. Although I started learning Erlang and found it easy to learn, there were more issues related to Haskell, so I ended up working mostly with Haskell.

I really wanted to contribute to Erlang. So when there was an internal Klarna hackathon, I found my opportunity. We were using something called JSON Schema Validation and the library was still based on Draft-04 of the specification. I thought I could update it to Draft-06 during the hackathon [1]. It was an iteration, and nearly finished everything. The next day, I simply asked my manager if I could complete the rest.

#### What are some of your favorite technical highlights in Erlang/OTP, Elixir, etc. that have occurred over the past few years?

Personally, I think the use of documentation attributes in Erlang is extremely useful. I’ve worked with some parts of it, which is why I believe it’s so important. Before documentation attributes, we had edoc — which we still maintain — but it’s not something the Erlang/OTP team actively uses for our own documentation. We also had an XML format for generating Erlang documentation, but it was a bit tricky to work with. Ultimately, switching to documentation attributes and writing everything in Markdown was a great idea for producing better documentation. There are still some corner cases that we would like to fix in the future.

Another highlight, of course, is the JIT. In many languages, there’s something called a tracing JIT. The JVM, for example, uses a tracing JIT, where it checks at runtime whether it’s worth optimizing certain patterns. However, Erlang doesn’t do that. Instead, we use something called a template-based JIT. I don’t think there are many programming languages out there doing the same.

When it comes to Elixir, I’ve been following the Phoenix framework from the sidelines, and I think it’s excellent for web development. If you’re working in web development, I’d certainly recommend using Elixir. One notable recent update is the release of type inference, which I believe is due to their integration and experiments with set-theoretic types. Coming from a background in typed theory, I find this really important. I’m excited to see how this evolves over time.

#### As a core member of the Erlang/OTP team, can you give us some insights into your current work and the challenges you face in this team? What does the Erlang/OTP team do?

I work on the Erlang/OTP team at Ericsson. This team is responsible for developing and maintaining the Erlang programming language (including the compiler, virtual machine, etc.) as well as the set of libraries that come with it (OTP), such as the SSL library, gen_servers, and more. These libraries are designed to help developers create robust and fault-tolerant applications.

As a core member of the Erlang/OTP, I worked a bit on the documentation attributes, but Lukas Larsson is the one that did all the heavy lifting, so all glory should go to him. From my side, there was a need to create a Markdown parser, because the Erlang emulator (shell) needs to render the documentation. Since Markdown is used for documentation attributes, the goal was to display the Markdown nicely in the Erlang shell. To achieve this, we parse the Markdown into an abstract syntax tree (AST) with a structure similar to HTML. This structure is what the internals of the shell understand when displaying documentation. The transformation from Markdown to HTML-AST is not exactly the same as what we used to have, but the parser still produces pretty accurate HTML-AST and we did not have to re-write the internals of the shell.


I would like to see  if I can take this internal Markdown parser and put it directly as an OTP application. I think it would be a valuable contribution for those who need to parse Markdown. We’ll see if I can get it ready for OTP 28.

I originally came from the protocols team, but I’ve now moved to the virtual machine team, where I’m learning the ropes and working on optimizations. For now, I hope to make a small contribution by improving list comprehensions. There's a specific case where we can reduce the allocation of certain types of objects, and I think I can contribute to that.

Another challenge for me is that, as a board member of the Erlang Ecosystem Foundation, I’m trying to bring research back to Erlang. Many communities heavily benefit from research in languages like Haskell and OCaml, but I don’t believe there’s as much research in Erlang. I’m exploring ways for the Erlang/OTP team to collaborate with various research institutions.

We’ve submitted one EU project proposal, as well as some others locally here in Sweden. So far, they’ve been rejected, but that doesn’t mean we won’t get there. It just means we need to work a bit harder on them. I believe it’s only a matter of time before we can attract researchers back to Erlang to foster more innovation within the BEAM.

#### You're co-chairing the Erlang Workshop for the second year in a row. What has this experience been like, and why do you believe it's important to participate? 

This is my second year, and I hope to continue for a third, but that depends on the steering committee. The experience has been great; it involves a lot of work on the organizational side. My co-chair, [Laura Voinea](https://scholar.google.co.uk/citations?hl=en&user=aXxC7OcAAAAJ "Laura Voinea"), and I work very well together, which I believe is reflected in the quality of this year's workshop. We received numerous high-quality submissions, and I’m really happy with how everything has turned out.

I believe there are several reasons why participation is important. If you work in **industry**, it would be beneficial to submit papers that showcase proven patterns and solutions. I don’t think any solution needs to be perfect. You can submit something along the lines of, “For this scenario, we know how to implement a solution that works quite well.” I think that’s a valuable contribution because others can read and reference your paper, allowing them to address challenges you may not have known how to handle.. It's really great to have use cases.

From the **academic** point of view, I think if you want to know if your research is relevant for industry, this is a place to go and check. You can just work all you want on the theory, and that is a really important part. But if you want to see if this is applicable to a concurrent and distributed programming language, the Erlang Workshop is probably where you need to be. You can submit ongoing work and interact with industry and academics. You're going to get lots of feedback. In this year’s Workshop, there were great discussions. 

Finally, as a **participant**, if you want to know more or less what is the latest that's going on in the BEAM ecosystem, then you should participate. You are going to make academic contacts, in case you need that part of the innovation side. And if not, you're still going to meet plenty of people from industry. I think it's really important to continue building this up so that we can do great things together.


#### What aspects of the future of Erlang/OTP excite you the most? Is there a particular development you're eagerly anticipating?

John Högberg, from the OTP team is working on compiler verification in Erlang. The main idea is to verify that the optimized code preserves semantics. This means that you have your Erlang code, we perform some optimizations in the compiler, and we want to see that we haven't broken any of the invariants after the optimisations, because the Virtual Machine will crash in that case.

If his work is successful, it will enable us to perform more aggressive optimizations that we currently cannot prove and apply. This research is extremely important. We are exploring the possibility of partnering with a Swedish university for their guidance. 

I am also excited about the potential for set-theoretic types in Elixir and possibly in Erlang. We've spoken with the leading academic in this area, Giuseppe Catagna, and we also want to discuss it with José Valim to explore the possibility of integrating this into Erlang. As I understand, set-theoretic types are quite similar to success typing, which is what Dialyzer uses. But set-theoretic types are more powerful than success typing and they seem to have only minor differences. It's worth exploring how we can achieve more static guarantees in Erlang without changing almost any type. 

Last, it would be fascinating to see if we can call Elixir code from Erlang in an easier way. Hopefully this will come sooner than later.

#### What motivated you to join the Erlang Ecosystems Foundation, and what role do you see the foundation playing in the community's future?

I always wanted to contribute to a non-profit organization. During my Master's studies, I collaborated with a non-profit organization called [Doctors Without Borders](https://www.msf.org/spain). There, I had to create a prototype for the learning platform, and I kind of succeeded. I don't think in the end they used it, but it was a really good experience.


For the Erlang Ecosystem Foundation, I really wanted to contribute to the community, and with our manager Kenneth retiring from Ericsson, I thought it would be a great opportunity to step in. My goal was to help the community and articulate the challenges we face in Erlang/OTP, particularly for those issues where we lack resources.

While I can contribute outside of the board, being a board member allows me to advocate for potential stipends for work that we consider interesting and explore solutions that could benefit us, Erlang/OTP and the BEAM ecosystem. It was really important to me to run for the board, and I feel fortunate to have been elected

I think the foundation is going to be really important in the future and this is due to the Cyber Resilience Act which is coming at the end of this year. Companies will have approximately three years to implement security measures. In this context, the Erlang Ecosystem Foundation is taking the lead in community efforts to explore pathways that will help BEAM developers and companies using BEAM technology comply with the Cyber Resilience Act without having to undertake a massive amount of work.  We're doing some early work to try to understand how to help the community in the best way we can.

#### Why would you encourage others to get involved with the Erlang Ecosystems Foundation?

I believe that any programming language is only as strong as its community. A clear example of this is Python. It is a simple language, and it has a lot of libraries for nearly any task you want to accomplish. There are plenty of developers creating libraries, thus, helping the community. The community is strong because everyone contributes a little bit.

Watch the interview on our [YouTube Channel](https://youtu.be/lSm8-jA-gsM?si=P6O8ZCN9NNnUpnmn)

*We’re eager to hear your stories, please share them at marcom@erlef.org!*





