# Erlef

## Pre-requeisties 

 - erlang/otp 22
 - elixir 1.9
 - node v12.x 

## Up and running

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Creating blog posts

The eef.gen.post mix task should be used to create new blog posts. The command structure is as follows:

`mix eef.gen.post <working-group> <slug>`

The current options are available:

 - --author <string> | -a <string>
 - --title <string>  | -t <string>
 
Note that you may edit the author, title, and other meta data after the post is generated.

```shell
mix eef.gen.post education missing-rug --author "The Dude" --title "It tied the room together"
* creating priv/posts/education/20190708231334_missing-rug.md
```
Now you may open up the created file and edit the metadata and author the content of your post with your favorite editor.

In this example to preview the rendered markdown on the local instance of the site one would visit
`http://localhost:4000/blogs/education/missing-rug`

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
 See https://hexdocs.pm/earmark/1.3.2/Earmark.html for details. 

```

### Current roster of blog groups

 The following groups can be used with the eef.gen.post command:

 - building 
 - education
 - marketing
 - proposal
 - observability
 - sponsorship
 - security
