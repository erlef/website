{
  "description": "To evolve the tools in the ecosystem related to building and deploying code, with a strong focus on interoperability between BEAM languages",
  "email": null,
  "formed": "2019-04-30",
  "gcal_url": null,
  "github": "erlef/eef-build-and-packaging-wg",
  "volunteers": [
    {
      "image": "volunteers/tristan-sloughter.jpg",
      "name": "Tristan Sloughter",
      "is_chair": true
    },
    {
      "image": "volunteers/fred-hebert.png",
      "name": "Fred Hebert"
    },
    {
      "image": "volunteers/bryan-paxton.jpg",
      "name": "Bryan Paxton"
    },
    {
      "image": "volunteers/todd-resudek.jpg",
      "name": "Todd Resudek"
    },
    {
      "image": "volunteers/randy-thompson.jpg",
      "name": "Randy Thompson"
    },
    {
      "image": "volunteers/wojtek-mach.jpg",
      "name": "Wojtek Mach"
    },
    {
      "image": "volunteers/profile-placeholder.png",
      "name": "Ivan Glushkov"
    },
    {
      "image": "volunteers/andrea-leopardi.jpg",
      "name": "Andrea Leopardi"
    },
    {
      "image": "volunteers/profile-placeholder.png",
      "name": "Justin Wood"
    },
    {
      "image": "volunteers/jose-valim.jpg",
      "name": "José Valim"
    },
    {
      "image": "volunteers/profile-placeholder.png",
      "name": "Thomas Depierre"
    },
    {
      "image": "volunteers/adam-lindberg.jpg",
      "name": "Adam Lindberg"
    },
    {
      "image": "volunteers/maxim-fedorov.jpg",
      "name": "Maxim Fedorov"
    },
    {
      "image": "volunteers/profile-placeholder.png",
      "name": "John Hogberg"
    }
  ],
  "name": "Building and Packaging",
  "slug": "building-and-packaging"
}
---
EEF Building & Packaging Working Group
---

## Mission Statement
Evolve the tools in the ecosystem related to building and deploying code, with a strong focus on interoperability between BEAM languages

## Main Objectives
- Provide improved options for managing and deploying packages, and other dependencies
- Compiling and Deploying mixed-languages projects

## Benefits to the community
- Better integration between various languages: since languages like Erlang, Elixir, LFE, or Efene all tend to be used in slightly different parts of the industry, the ability to interoperate better across all languages benefits each language individually as well, by providing more mobility and a broader pool of libraries to use, along with a more uniform experience within each language
- The current tool ecosystem is generally understaffed within each language. By pooling resources, developer time, and focusing on interoperability, we can hope for better sustainability
- The current tool ecosystem requires infrastructure support for builds, documentation, and other various hosting costs that are often paid for by the maintainers directly. While some tools (i.e. hex.pm) can self-sustain from commercial customers, we believe that some funding by the foundation would allow to focus on good solutions rather than just solutions that are affordable for individual maintainers.

## Short term deliverables
- Support efforts related to EEP48 (documentation chunks) integration into build tools
- Instructions/tutorials for self-hosted hex package indexes
- Improved usability of cross-language dependencies in projects

## Long term deliverables
- Figure out better configuration mechanisms for releases both in distillery and relx
- Provide hermetic builds for hex packages based on auto-generated local indexes
- Resolving issues regarding versioning conflicts between Rebar3 and mix-based packages
- relx/rebar3 feature equivalence with reltool
- Improved support for best practices around building and running releases for containerized environments

## Why does this group require the Foundation
While tooling has been self-sufficient for years, there have been recent ongoing efforts at unifying part of the infrastructure required for packages. This has forced increased levels of communication across the various sub-communities of the ecosystem, and an attempt to align efforts.

Most of these turn out to be ad-hoc and done in private communication channels that lack visibility. By making these efforts public and traceable, we hope to get better results and involvement from all the involved communities, while providing more leverage when changes require involvement in other codebases, such as Erlang/OTP itself.

We also hope to be able to better align resources when it comes to providing improved accessibility, such as offering package mirrors or pre-built tool binaries, and possibly pool work towards shared libraries (i.e. hex_core, but also libraries offering portability for filesystems, and so on)

## Initial list of volunteers
- Tristan Sloughter (Rebar3, relx)
- Wojtek Mach (Hex)
- Fred Hebert (Rebar3)

-------
