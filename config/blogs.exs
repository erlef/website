use Mix.Config

config :erlef, :blogs, [
  {"marketing", %{name: "marketing", module: Erlef.Blogs.Marketing}},
  {"education",
   %{
     name: "education",
     module: Erlef.Blogs.Education,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean acinia bibendum nulla sed consectetur."
   }},
  {"fellowship",
   %{
     name: "fellowship",
     module: Erlef.Blogs.Fellowship,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean acinia bibendum nulla sed consectetur."
   }},
  {"sponsorship",
   %{
     name: "sponsorship",
     module: Erlef.Blogs.Sponsorship,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean acinia bibendum nulla sed consectetur."
   }},
  {"security",
   %{
     name: "security",
     module: Erlef.Blogs.Security,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean acinia bibendum nulla sed consectetur."
   }},
  {"observability",
   %{
     name: "observability",
     module: Erlef.Blogs.Observability,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean acinia bibendum nulla sed consectetur."
   }},
  {"proposal",
   %{
     name: "proposal",
     module: Erlef.Blogs.Proposal,
     about:
       "Etiam porta sem malesuada magna mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean acinia bibendum nulla sed consectetur."
   }}
]
