{
  "title": "Inside the Erlang/OTP 26 release with Björn Gustavsson",
  "authors": ["The Marketing Working Group"],
  "slug": "inside-otp-26",
  "category": "marketing",
  "tags": ["developer", "marketing", "erlang", "otp"],
  "datetime": "2023-05-29T14:48:19.825190Z"
}
---
Inside the Erlang/OTP 26 release with Björn Gustavsson
---

Erlang/OTP 26 is finally here, and we discuss its improvements with Björn Gustavsson, one of its contributors and a member of our Foundation.

<img src="/images/inside-otp-26.png" width="100%" height="auto" alt="Inside Erlang/OTP 26"/>

<br/>
<br/>

**This new Erlang/OTP version has new features, some of them are implemented for the first time, others are enhancements
over existing features. What can you tell us about these improvements?**

Regarding the selection of new features, there is usually a workshop once a year to collect ideas and see what the internal customers want and what the open source users want. Then we have some ideas ourselves and we put them in a long list to prioritize them and determine how much we can include in the release.

I work in the VM Team and I specialize in the compiler and JIT, so I am going to start with the JIT. The Erlang/OTP 24 was the first implementation of the JIT and we knew that we could do more optimizations than we had time to do in that release. We noticed that the Erlang compiler knows alot more about the types than the JIT knows. For example, if we have an arithmetic operation, such as the `+` operator, and the JIT doesn’t know anything about the operands the JIT will need to emit code to handle float operands and incorrect operands and also overflow resulting from the addition.

In order to handle all those cases, the JIT emits inlined code to do the simple thing of adding two integers, and all other cases are handled by calling a helper routine. We noticed that if the compiler could tell the JIT about the types, we could emit better native code, fewer instructions and fewer tests.

In OTP 25, we added the capability of the compiler to include type information in the generated BEAM files, so that the JIT could use it while generating code. For example, if the operands for **+** operation are known to be integers that are sufficiently small, the addition cannot result  in an overflow. In that case it can do the addition without the need of any tests and that will be faster, especially for long sequences of expressions.

In OTP 26 we extended the type based optimizations, by making the compiler smarter so it could figure out more about the types, and by implementing more optimizations in the JIT to take advantage of the better types, resulting in better native code.

But the big thing that we did in OTP 26 was in the improvements of the binary syntax to construct and match binaries. The JIT in OTP 24 and OTP 25 did not substantially improve the efficiency of the binary syntax. We knew that we could make it much more efficient.

In OTP 26, we changed the compiler so it could emit a single instruction that included construction of all segments in the binary. For example, if you wanted to construct three segments each 8 bits, the JIT emits code that first constructs the contents of the binary in a CPU register, 24 bits (three bytes), and then writes that to the binary being constructed. That will be much faster than constructing and writing each segment to memory one by one. We did a similar thing with binary matching. Let's say we want to match four segments each 6 bits, that is, 24 bits. We will do that by reading 24 bits (three bytes) from memory and then we will shift and mask to extract those values, which is much faster. We knew that the base64 module would be a very good benchmark for that.

We ended up with about four times faster results doing Base64 encoding and three times faster for decoding Base64. We changed the source code for the base64 module, it took advantage of all these sections we implemented to do some tricks and now the base64 code is written in a much more straightforward way. I found examples in the blog post about that.

For more details about the new optimizations, see the blog post [More Optimizations in the Compiler and JIT](https://www.erlang.org/blog/more-optimizations).

Regarding the Shell, we have been thinking about improving it for a long time. It turned out for this release that there was a new employee that was interested in improving the shell and he also was learning Erlang and he was used to other languages which had better support for completion. That's why we prioritized the Shell for this release.

The built-in type dynamic() was a suggestion from the WhatsApp team at Meta. They wanted it for the eqWAlizer and also for the Gradualizer. Dialyzer does not really have traditional types, so it does not need dynamic() but all traditional type checkers need it. For Dialyzer the dynamic() is the same as any() or term().

Map comprehension was an obvious missing feature that we were thinking of doing because we already had list comprehensions and binary comprehensions. There was a solid [EEP](https://www.erlang.org/eeps/eep-0058) and an [implementation](https://github.com/erlang/otp/pull/6727) that we could build upon. It is nicer to write a map comprehension than constructing a list and call `map:from_list/1` on the result. Also, using a map generator in a comprehension will be somewhat more efficient than using a map iterator.


**In your opinion, which features are going to have more impact in the community?**

It will vary depending on the use. I think most users will appreciate the new Shell, for example to be able to define functions in it. Applications that use the binary syntax could see some significant improvements, and all users will benefit from the compiler and JIT optimizations to some extent. Users that run Dialyzer on a large code base will benefit from the incremental mode of Dialyzer. At WhatsApp, incremental mode has made Dialyzer up to seven times faster.

**What can we expect for Erlang/OTP 27? Is there any feature in particular that you want to share with us?**

We don't make any promises because some features turn out to be more difficult to implement than what we thought initially. But we have some ideas, the main thing is about documentation: to improve the tools to write documentation both for the documentation of OTP itself and also for users to make something easier and fun to use.

It will probably be possible to write the documentation in Markdown, because Markdown is widely known and we think that it's a good choice. It will probably be possible to put documentation inside Erlang files, if you want to do that, and it will also be possible to put it outside the files. I suppose it depends on how much documentation you need to write for the module.

Then we will always try to include some new language features. We have a list of a few ones that we haven't decided which one to go for yet. And then of course, there will be more optimization on the compiler, JIT and the runtime system to improve performance.

*We're eager to hear your stories, please share them
at <marcom@erlef.org>!*
