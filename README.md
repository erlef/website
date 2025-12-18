# Erlef

![CI](https://github.com/erlef/website/workflows/test/badge.svg)

This is the repo for the [erlef.org](https://erlef.org/) website.

## Contributing to `erlef/website`

We want to make contributing to this project as easy and transparent as possible.

### Our Development Process

We use GitHub to sync code to and from our internal repository. We'll use GitHub to track issues and feature requests, as well as accept pull requests.

### Pull Requests

We actively welcome your pull requests.

1. Fork the repo and create your branch from `main`.
1. If you've added code that should be tested, add tests. (if in doubt, ask)
1. If you've changed APIs, update the documentation.
1. Ensure the test suite passes.
1. Make sure your code lints.
1. When contributing be sure to accept our required acknowledgement of non-favouritism.

### Issues

We use GitHub issues to track public bugs and feature requests. Please ensure your description is clear and has sufficient instructions to be able to reproduce the issue, or describe the intended feature.

### License

By contributing to erlef/website, you agree that your contributions will be licensed under its Apache License Version 2.0.

## Installation

This application is using [Phoenix](https://phoenixframework.org), the [most loved web framework](https://survey.stackoverflow.co/2025/technology/#2-web-frameworks-and-technologies), written in Elixir.

### Prerequisites

 A `.tool-versions` file is provided in this repo for [asdf](https://asdf-vm.com/) users.

- Erlang/OTP 23
- Elixir 1.11
- NodeJS v10 (or greater)

### Up and running

- Install Elixir dependencies with `mix deps.get`
- Install Node.js dependencies with `npm install --prefix assets`
- Run `mix ecto.setup` to setup the local database
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Creating blog posts

The eef.gen.post mix task should be used to create new blog posts. The command structure is as follows:

`mix eef.gen.post <working-group> <slug>`

The current options are available:

- `--author <string>` or  `-a <string>`
- `--title    <string> ` or `-t <string>`

Note that you may edit the author, title, and other meta data after the post is generated.

```shell
mix eef.gen.post education missing-rug --author "The Dude" --title "It tied the room together"
* creating priv/posts/education/20190708231334_missing-rug.md
```

Now you may open up the created file and edit the metadata and author the content of your post with your favorite editor.

In this example to preview the rendered markdown on the local instance of the site one would visit
`http://localhost:4000/news/education/missing-rug`

### Post file format

```
{
  "title": "It tied the room together",
  "author": "The Dude",
  "slug": "missing-rug",
  "datetime": "2019-07-08T23:12:30.345164Z"
}
---
Post excerpt goes here. This is a short description of the what the post is about.
---
This is where the body of the post goes.

## Standard markdown and GFM supported.
 See [Earmark Docs](https://hexdocs.pm/earmark/1.3.2/Earmark.html) for details.

```

### Current roster of blog groups

 The following groups can be used with the eef.gen.post command:

- eef
- building
- education
- marketing
- proposal
- observability
- sponsorship
- security
- documentation

## Development

### Getting around in dev mode

- No extra configuration is needed to getting up and running in dev mode.
  Simply start up the app after initializing the database and login.
- You may login in with different personas in dev mode using the `Login as` dropdown menu.

### Contributing to the community section of the site

All resources data for the community page of the site can be found in [priv/data/community](priv/data/community).

Before proceeding please:

- Stick to facts about entries you add and avoid asserting comparative or superlative differences of one product,
  project, company or individual over another.
- Note than an `about` value for sections of the page that make use of cards can have no more than 240 characters and
  optimally have no less than 200 characters.

#### Adding an entry to an existing section

To add an entry to an existing section simply find the relevant `.exs` file in  [priv/data/community](priv/data/community) and add a new entry. That's it!

#### Adding a new section or sub-section

- Create a new `.exs` file in [priv/data/community](priv/data/community) with a name that reflects the section of the site (e.g, languages, platforms, etc.)
  - See [priv/data/community/languages.exs](priv/data/community/languages.exs) as an example.
- A new function should be able after you recompile `Erlef.Community.Resources` with the base name of the file you added prefixed with `all_` (e.g., `all_languages`). Likewise it will also be available in the main data map returned by the `all/0` function.
- Add the new section or sub-section
  to [lib/erlef_web/templates/page/community.html.eex](lib/erlef_web/templates/page/community.html.eex).
  - Note that both `<h1>` and `<h2>` tags within this file will automatically end up within the TOC component on the
    page. Deeper nesting is not supported. See existing sections for examples.
  - The layout for what you're adding may depend on the type of section and there are are no hard rules around how
    something should be displayed. If you're unsure or need feedback please reach out to us in an issue or as
    part of a pull request.
- Commit your changes and open up a new pull request using the Community Section pull request template 🎉
