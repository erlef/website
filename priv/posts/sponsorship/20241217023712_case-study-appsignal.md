{
    "title": "Case study: Application Performance Monitoring (APM) tool","authors": ["Sponsorship"],
    "slug": "case-study-app-signal",
    "category": "sponsorship",
    "tags": ["sponsorship", "meet-the-sponsors"],
    "datetime": "2024-12-17T02:37:12.810583Z" }

# Case study: Application Performance Monitoring (APM) tool

AppSignal is a powerful Application Performance Monitoring (APM) tool designed to help developers build scalable and reliable applications. Originally known for its strong support of Ruby on Rails applications, AppSignal has expanded its capabilities to offer APM tools for a variety of programming languages, including Elixir, Ruby, Node.js, and Python. 

<img src="priv/posts/sponsorship/CaseStudy-AppSignal.png" class="img-fluid" alt="Case Study - AppSignal"/>

This case study explores AppSignal's entry into the Elixir ecosystem and its ongoing efforts to provide developers with valuable insights into their applications.

The company initially focused on providing APM solutions for Ruby on Rails applications. As Elixir gained popularity particularly among developers transitioning from Ruby, AppSignal saw an opportunity to expand its expertise. In 2017, the company released an Elixir integration package, making it the first APM solution to offer full support for Elixir applications.

An interesting aspect of this experience is that AppSignal operates entirely as a remote company, with its team members spread across Europe. Despite this geographical diversity, they successfully maintained collaboration through asynchronous workflows.

### Technologies and Tools Used

AppSignal provides integrations for Ruby, Elixir, Node.js, and Python, with Rust powering performance-intensive tasks across all these platforms. For its Elixir integration, the team focused on supporting popular libraries such as Plug, Phoenix, Ecto, Absinthe, Finch, Oban, and Tesla. Additionally, AppSignal provides  automatic dashboards that display Oban and Erlang VM data, giving users deeper insights into their Elixir applications.

### Architectural Structure of the Elixir Integration

The early stages of Elixir integration were challenging due to the lack of standardized instrumentation and telemetry support. As a result, AppSignal's team had to build much of the necessary instrumentation from the ground up.

Initially, integrating AppSignal with Elixir required manual work, such as wrapping libraries and functions to collect the necessary performance data. For example, AppSignal for Phoenix initially included its own custom view module that wrapped around Phoenix's own view system.

Over time, as [telemetry](https://github.com/beam-telemetry/telemetry) gained widespread adoption across the Elixir ecosystem, AppSignal was able to streamline the integration process. For the Phoenix integration, this means that installing AppSignal involves adding the library as a dependency and configuring your API key. This is the case for all Elixir frameworks they support. You install the Elixir package, and don't need to install any other monitoring dependency packages.

### Benefits of Choosing Elixir

The growing popularity of Elixir, particularly among Ruby developers who formed a significant part of AppSignal's customer base, made it a strategic addition to the company’s ecosystem. Expanding into Elixir enabled AppSignal to provide a seamless experience for existing customers monitoring both Ruby and Elixir applications. At the same time, it allowed the company to address the needs of the expanding Elixir developer community.

*Our foundation is supported by the funding of our sponsors, and it is what allows us to carry out projects, marketing initiatives, stipends programs, and accomplish the goals that we have established as an organization. So if you are interested in becoming a sponsor, contact us at sponsorship@erlef.org. We look forward to hearing from you!*
