defmodule Erlef.Fellows do
  @moduledoc false

  @fellows [
    %{
      name: "Bjarne Däcker",
      about:
        "Bjarne Däcker worked 36 years at Ericsson, first as programmer and systems designer, contributing to EriPascal, a concurrent version of Pascal and the last 18 years as founder and manager of the Computer Science Laboratory. At the Computer Science Lab, he oversaw the creation of Erlang and project managed the first release of OTP. Bjarne has also been one of the drivers of the Erlang User Conference when it was hosted by Ericsson. Bjarne Däcker holds a licentiate of technology from the Royal Institute of Technology, titled Concurrent Functional Programming for Telecommunications: A Case Study of Technology Introduction.
      ",
      avatar: "/images/fellows/bjarne_däcker.png"
    },
    %{
      name: "Joe Armstrong",
      about:
        "Joe Armstrong is the co-inventor of the Erlang programming Language and coined the term \"Concurrency Oriented Programming\". He has worked for Ericsson where he developed Erlang and was chief architect of the Erlang/OTP system. He took the initiative and suggested the computer science laboratory invent their own programming language, and followed up the idea suggesting they write a book about it. In 1998 he left Ericsson to form Bluetail, a company which developed all its products in Erlang. In 2003 he obtained his PhD from the Royal Institute of Technology, Stockholm. The title of his thesis was \"Making reliable distributed systems in the presence of software errors.\" He returned to Ericsson and became Adjunct Professor of Computer Science at the Royal Institute of Technology in Stockholm. He passed away in April 2019 from complications related to pulmonary fibrosis.",
      avatar: "/images/fellows/joe_armstrong.jpg"
    },
    %{
      name: "Robert Virding",
      about:
        "Robert Virding was one of the original members of the Ericsson Computer Science Lab, and co-inventor of the Erlang language. He took part in the original system design and contributed much of the original libraries, as well as to the current compiler. While at the lab he also did a lot of work on the implementation of logic and functional languages and on garbage collection. He has also worked as an entrepreneur and was one of the co-founders of one of the first Erlang startups (Bluetail). He co-authored the first book (Prentice-Hall) on Erlang, and is regularly invited to teach and present throughout the world. He is currently a principal language Erlang at Erlang Solutions. He is also the creator of Lisp, Lua and Prolog implementations running on top of the BEAM.",
      avatar: "/images/fellows/robert_virding.png"
    },
    %{
      name: "Mike Williams",
      about:
        "Mike Williams co-founded the Ericsson Computer Science Laboratory in 1984 where, among other things, he co-created Erlang. Mike's developed the first Erlang virtual machine and worked out the primitives for fault handling and dynamic code replacement. Since the 1990s, Mike has been in charge of both large and small units within Ericsson which develop software, including platforms (with the Erlang/OTP team) and radio base stations. After his retirement from Ericsson he has among other things acted as chairman for the Erlang Industrial User Group which is where the initiative to EEF comes from.",
      avatar: "/images/fellows/mike_williams.jpeg"
    }
  ]

  def all(), do: @fellows
end
