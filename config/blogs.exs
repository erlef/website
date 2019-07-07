use Mix.Config

config :erlef, :blogs, [
  {"marketing",
   %{
     repo: Erlef.Blogs.Marketing,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum."
   }},
  {"education",
   %{
     repo: Erlef.Blogs.Education,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum."
   }},
  {"fellowship",
   %{
     repo: Erlef.Blogs.Fellowship,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum."
   }},
  {"sponsorship",
   %{
     repo: Erlef.Blogs.Sponsorship,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum."
   }},
  {"security",
   %{
     module: Erlef.Blogs.Security,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum."
   }},
  {"observability",
   %{
     repo: Erlef.Blogs.Observability,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum."
   }},
  {"proposal",
   %{
     repo: Erlef.Blogs.Proposal,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum."
   }}
]
