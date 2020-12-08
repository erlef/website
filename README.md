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
  * Run `mix ecto.setup` to setup the local database
  * Start Phoenix endpoint with `mix phx.server`

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
- No extra configuration is needed to getting up and running in dev mode. Simply start up the app after
  initializing the database and login. 
- You may login in with different personas in dev mode using the `Login as` dropdown menu. 

### Contributing to the community section of the site

All data for the community page of the site can be found in [lib/erlef/community](lib/erlef/community).

Before proceeding please:

   -  Stick to facts about entries you add and avoid asserting comparative or superlative differences of one product, 
      project, company or individual over another.
   -  Note than an `about` value for sections of the page that make use of cards can have no more than 240 characters and
      optimally have no less than 200 characters.

#### Adding an entry to an existing section

  To add an entry to an existing section simply find the relevant module in  [lib/erlef/community](lib/erlef/community)
  and add a new entry in the form of a map. 

#### Adding a new section or sub-section 

  - Create a new module with a name that reflects the section of the site (e.g, languages, platforms, etc.) within
    the [lib/erlef/community](lib/erlef/community) directory. 
    
    - See [lib/erlef/community/languages.ex](lib/erlef/community/languages.ex) as an example. 

  - Update [lib/erlef/community.ex](lib/erlef/community.ex) to make use of the new module.

  - Add the new section or sub-section
    to [lib/erlef_web/templates/page/community.html.eex](lib/erlef_web/templates/page/community.html.eex).
    
    - Note that both `<h1>` and `<h2>` tags within this file will automatically end up within the TOC component on the 
      page. Deeper nesting is not supported. See existing sections for examples.

    - The layout for what you're adding may depend on the type of section and there are are no hard rules around how
      something should be displayed. If you're unsure or need feedback please reach out to us in an issue or as 
      part of a pull request.

  - Commit your changes and open up a new pull request using the Community Section pull request template 🎉
