{
  "title": "Case Study: Sora - Shiguredo",
  "authors": ["Sponsorship"],
  "slug": "case-study-sora-shiguredo",
  "category": "sponsorship",
  "tags": ["sponsorship", "meet-the-sponsors"],
  "datetime": "2025-10-27T03:37:12.810583Z"
}
---
Shiguredo is a product company based in Tokyo, Japan, that develops Sora, a WebRTC SFU (Selective Forwarding Unit) for real-time audio, video, and data. Sora powers everything from interactive meetings to large-scale live streams. 
---
Shiguredo is a product company based in Tokyo, Japan, that develops Sora, a WebRTC SFU (Selective Forwarding Unit) for real-time audio, video, and data. Sora powers everything from interactive meetings to large-scale live streams. 

<img src="/images/meet-the-sponsors/Shiguredo-casestudy.png" class="img-fluid" alt="Case Study - Shiguredo"/>

#### The Birth of Sora

Sora was launched in 2015, developed entirely in Erlang/OTP. From the very beginning, the team identified that Pure P2P WebRTC had practical limits for group calls and broadcasts. Anticipating the shift toward server-assisted WebRTC, Shiguredo started development early, positioning Sora ahead of the curve.

#### Team and Process

Sora has been developed by a fully remote team of several engineers, working with asynchronous stand-ups and thorough code reviews. The system itself is entirely written in Erlang/OTP, with Python + pytest used for end-to-end testing. 

The Sora project makes extensive use of tools and libraries from the BEAM ecosystem and beyond, including:

- rebar3 and relx.
- ELP — used as a stable LSP.
- efmt — a fast, Rust-based formatter.
- RabbitMQ's ra — a stable Raft library.
- gproc — a stable process-registry library (sponsored by Shiguredo).
- Cowboy / Gun — stable HTTP libraries (sponsored by Shiguredo).

Beyond their usage, Shiguredo actively contributes back to the community:

- Long-time sponsor of AsmJit, critical for native code generation.
- Sponsors of gproc and Cowboy via GitHub Sponsors.

While most of their own libraries remain closed-source, their sponsorship ensures that essential open source projects continue to thrive.

#### Overcoming Challenges

At the start of development, Erlang/OTP did not include DTLS (Datagram Transport Layer Security). To meet their requirements, the team implemented a custom Erlang-based DTLS stack, ensuring security and compliance from day one.

In its ten years of production use, Sora has experienced only one notable incident (a segmentation fault caused by a memory leak). Otherwise, the platform has delivered continuous service with zero unplanned downtime — a testament to the stability of Erlang/OTP and Shiguredo’s engineering practices.

For more details, visit the Sora official [website](https://sora.shiguredo.jp/).

*Our foundation is supported by the funding of our sponsors, and it is what allows us to carry out projects, marketing initiatives, stipends programs, and accomplish the goals that we have established as an organization. So if you are interested in becoming a sponsor, contact us at [sponsorship@erlef.org](mailto:sponsorship@erlef.org). We look forward to hearing from you!*
