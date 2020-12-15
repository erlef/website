{
  "description": "Facilitate the reuse of software components that target the Erlang Runtime.",
  "email": "language-interop@erlef.org",
  "formed": "2020-02-01",
  "gcal_url": null,
  "github": null,
  "volunteers": [
    {
      "image": "volunteers/profile-placeholder.png",
      "name": "Robert Virding"
    },
    {
      "image": "volunteers/jose-valim.jpg",
      "name": "José Valim"
    },
    {
      "image": "volunteers/kenneth-lundin.jpg",
      "name": "Kenneth Lundin"
    },
    {
      "image": "volunteers/mariano-guerra.jpg",
      "name": "Mariano Guerra",
      "is_chair": true
    }
  ],
  "name": "Language Interoperability ",
  "slug": "language-interop"
}
---
EEF Language Interoperability Working Group
---

## Mission Statement
The mission of the working group is to facilitate the reuse of software components that target the Erlang Runtime, no matter in which language they were created.
To reduce the friction and boilerplate required to use functionality implemented in one language from another, ideally making it look the same as if the functionality was implemented in the language being used.
To identify common abstractions and requirements duplicated in the languages and provide functionality in the platform to avoid duplication and incompatibilities.
A secondary objective is to facilitate the interaction between the Erlang Ecosystem and its languages with external languages and platforms that provide complementary functionality.

## Benefits to the community
- Provide access to software components implemented in other languages that behave as close to the language being used as possible.
- Avoid wasting effort by reimplemented functionality already available on the platform.
- Provide visibility and unified access to functionality available in other languages.
- Serve as a place to discuss compatibility and interoperability between languages.
- Provide access to external languages and platforms that complement and extend the
functionality of the BEAM Platform.
- Provide functionalities that ease the implementation of programming languages on the
platform.

## Short term deliverables
- Erlang Enhancement Proposals (EEPs) for already identified interoperability areas.

## Long term deliverables
- Module Aliasing functionality to allow each language refer to modules implemented in other languages using the native naming convention.
- User Defined Types functionality in the platform to unify representations currently implemented at the compiler level on each language.
- Guidelines for how to design components and APIs that behave as native implementations across all languages on the BEAM.

## Why does this group require the Foundation
The topics involve people from different communities and organizations, the changes affect languages, runtimes, the BEAM platform but also programmers of languages that use the platform.
These changes require backing from the foundation to bring the people together and decide on important changes that must be implemented and maintained by all actors.

## Initial list of volunteers
- Mariano Guerra
- Robert Virding
- Kenneth Lundin
- José Valim

-------
