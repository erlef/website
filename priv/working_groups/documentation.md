{
  "description": "Improve the accessibility, interoperability and quality of the documentation across projects and languages in the Erlang Ecosystem.",
  "email": "documentation@erlef.org",
  "formed": "2019-07-23",
  "gcal_url": null,
  "github": null,
  "members": [
    {
      "image": "members/jose-valim.jpg",
      "name": "José Valim"
    },
    {
      "image": "members/fred-hebert.jpg",
      "name": "Fred Hebert"
    },
    {
      "image": "members/kenneth-lundin.jpg",
      "name": "Kenneth Lundin"
    },
    {
      "image": "members/mariano-guerra.jpg",
      "name": "Mariano Guerra"
    },
    {
      "image": "members/radek-szymczyszyn.jpg",
      "name": "Radosław Szymczyszyn"
    },
    {
      "image": "members/laszlo-bacsi.png",
      "name": "László Bácsi"
    }
  ],
  "name": "Documentation",
  "primary_contact_method": "email",
  "slug": "documentation"
}
---
EEF Documentation Working Group
---

## Mission Statement
Improve the accessibility, interoperability and quality of the documentation across projects and languages in the Erlang
Ecosystem.

## Main Objectives
- Allow documentation to be accessed and shared across different languages in the Erlang Ecosystem (as it pertains to EEP
48)
- Improve the user experience in writing, generating, and reading documentation from the shell, IDEs, web pages, etc.
- Be a central point for language designers, library authors, and tool maintainers to learn, discuss, propose, and improve
the current best practices related to documentation

## Benefits to the community
- Better integration between various languages: today IDE integrations written for Elixir cannot show documentation for
 Erlang projects, and vice-versa. The lack of interoperability often means developers would reimplement a library in
language X rather than use an existing library in language Y as to leverage the full toolset
- Share tools and ideas between languages: Erlang's documentation has man pages, other languages do not. Elixir provides
- EPUB generation and modern web front-end for documentation. By standardizing how documentation is written and accessed,
we write tools that work for all languages instead of fragmenting the community
- The current documentation ecosystem is generally understaffed within each language. By pooling resources, developer
time, and focusing on interoperability, we can hope for better sustainability


## Short term deliverables
- Adopt EEP 48 on EDoc to make it interoperable with other tools in the community, such as ExDoc. Given EDoc is the most
used documentation tool in the Erlang community, improving its outcome will push the ecosystem as a whole towards better
documentation and better tools
- Streamline generation and publishing of documentation across the existing build tools. For example, pushing a package to
- Hex should by default push users towards also publishing docs (this requires collaboration with the Building and
Packaging Working Group)

## Long term deliverables
- Guide languages towards adoption of EEP 48
- Define a documentation language to be used as a standard in the community
- Adopt said standard in Erlang/OTP and the existing tooling

## Why does this group require the Foundation
While EEP 48 has been a recent effort into unifying how documentation is managed in the Erlang Ecosystem, its adoption
has been slow. The working group will be a central point for language authors to learn about best practices and provide
feedback on the current standards, increasing EEP 48's adoption as well as improving the interoperability between
languages.

The adoption of EEP 48 may also require changes to existing tools. Some of these tools may be managed by other Working
Groups, which we aim to support. The Working Group may also need funding when it comes to enhancing and maintaining said
tools.

Note that it is not the goal of the Documentation Working Group to write and provide documentation for libraries and
tools it doesn't directly maintain. Although it is our goal to provide materials and resources for library authors to
instruct and push them towards writing documentation of great quality.

## Initial list of volunteers
- José Valim (Elixir, ExDoc)
- Kenneth Lundin (Erlang/OTP, EDoc)
- Radosław Szymczyszyn (Docsh)
- Fred Hebert (Rebar3)
- László Bácsi (ExDoc)
- Mariano Guerra (Efene)

-------
