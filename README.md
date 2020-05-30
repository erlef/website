# Erlef

![CI](https://github.com/erlef/website/workflows/CI/badge.svg)

## Prerequisites

 A `.tool-versions` file is provided in this repo for [asdf](https://asdf-vm.com/) users.

 - Erlang/OTP 22
 - Elixir 1.9
 - NodeJS v12
 - Yarn

## Up and running

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && yarn`
  * Run `mix do ecto.create, ecto.migrate` to setup the local database
  * Start Phoenix endpoint with `mix phx.server`
  * Load seed data
    - run `mix run priv/repo/academic_papers.exs`

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

### post file format

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
- copy .env-example to .env-local and source the file
- you may login in as an regular user in dev using member@erlef.test and any password
- you may login in as an admin in dev using admin@erlef.test and any password
