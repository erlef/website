{
  "title": "Machine Learning WG updates - Sep 2021",
  "authors": ["The Machine Learning WG"],
  "slug": "machine-learning-udpates-sep-2021",
  "tags": ["machine learning", "axon", "nx", "livebook", "explorer"],
  "category": "machine-learning",
  "datetime": "2021-09-30T12:34:56.921505Z"
}
---
Machine Learning WG updates - Sep 2021
---

Welcome to another update from the Machine Learning WG! This time we are glad to announce many improvements to our on-going efforts and welcome new projects into the fold!

## Nx updates

[Nx](https://github.com/elixir-nx/nx) is a multi-dimensional tensors library for Elixir with multi-staged compilation to the CPU/GPU.

* Refactored Nx' core to support TPUs ([https://github.com/elixir-nx/nx/pull/423](https://github.com/elixir-nx/nx/pull/423))

* Many new index-based operations were added, such as `Nx.take/3`, `Nx.take_along_axis/3`, `Nx.gather/2`, and `Nx.scatter_add/3`

* The EXLA backend (which uses Google's XLA) has been updated to Tensorflow 2.6 and now supports NVIDIA's Jeton and macOS aarch64

* We now precompile Google's XLA to multiple OSes and architectures. This brings the getting started experience down from several minutes to a couple seconds

## Explorer updates

We are glad to welcome [Explorer](https://github.com/elixir-nx/explorer/), led by Chris Grainger, into the Machine Learning WG and into the elixir-nx organization. Explorer is a dataframe library for Elixir. It is an API for data manipulation with high-level features such as:

* Simply typed series: float, integer, boolean, string, date, and datetime

* A powerful but constrained and opinionated API, so you spend less time looking for the right function and more time doing data manipulation

* Pluggable backends, providing a uniform API whether you're working in-memory or (forthcoming) on remote databases or even Spark dataframes

* The first (and default) backend is based on NIF bindings to the blazing-fast [polars](https://github.com/pola-rs/polars) library

Learn more about it in its [README](https://github.com/elixir-nx/explorer/) or in [its introductory notebook](https://github.com/elixir-nx/explorer/blob/main/notebooks/exploring_explorer.livemd).

## Livebook updates

[Livebook](https://github.com/elixir-nx/livebook/) is a collaborative and interactive code notebook in Elixir developed by Jonatan Kłosko.

* Add an explore section with many introductory notebooks on Livebook, Elixir, VM instrumentation, etc ([https://github.com/livebook-dev/livebook/pull/310](https://github.com/livebook-dev/livebook/pull/310))

* Introduce the Kino library: a Livebook client for building interactive charts, tables and more ([https://github.com/livebook-dev/livebook/pull/306](https://github.com/livebook-dev/livebook/pull/306))

* Make notebooks more interactive with the addition of inputs ([https://github.com/livebook-dev/livebook/pull/328](https://github.com/livebook-dev/livebook/pull/328)), which can be made reactive ([https://github.com/livebook-dev/livebook/pull/389](https://github.com/livebook-dev/livebook/pull/389)), and allow for multiple input types (colors, text area, urls, passwords, etc)

* Introduce branching sections to perform asynchronous work ([https://github.com/livebook-dev/livebook/pull/449](https://github.com/livebook-dev/livebook/pull/449))

* Support relative links within notebooks ([https://github.com/livebook-dev/livebook/pull/441](https://github.com/livebook-dev/livebook/pull/441))

* Hovering modules and function calls in the Elixir code editor now shows their documentation ([https://github.com/livebook-dev/livebook/pull/453](https://github.com/livebook-dev/livebook/pull/453))

* Allow notebooks to be exported to Elixir code ([https://github.com/livebook-dev/livebook/pull/476](https://github.com/livebook-dev/livebook/pull/476)) and Live Markdown, optionally with output ([https://github.com/livebook-dev/livebook/pull/483](https://github.com/livebook-dev/livebook/pull/483))

* Support for pluggable file-systems with S3 support out of the box: ([https://github.com/livebook-dev/livebook/pull/492](https://github.com/livebook-dev/livebook/pull/492))

Livebook has been moved to its own organization and it will launch their own website soon. The organization also hosts [Nerves Livebook](https://github.com/livebook-dev/nerves_livebook), led by Frank Hunleth, which provides a straightforward way to run Livebook on embedded devices and ships with many additions to teach Nerves to new developers through Livebook.

## Axon updates

[Axon](https://github.com/elixir-nx/axon/) is a library led by Sean Moriarity that brings deep learning to Elixir. It is powered by Nx and runs on the CPU/GPU.

* Axon now global pooling layers ([https://github.com/elixir-nx/axon/pull/86](https://github.com/elixir-nx/axon/pull/86))

* Axon handles mixed precision policies ([https://github.com/elixir-nx/axon/pull/74](https://github.com/elixir-nx/axon/pull/74))

* Axon supports callbacks ([https://github.com/elixir-nx/axon/pull/71](https://github.com/elixir-nx/axon/pull/71)) and metrics ([https://github.com/elixir-nx/axon/pull/67](https://github.com/elixir-nx/axon/pull/67))

* Added constant, bilinear, and adaptive_lp_pool (adaptive power average pool) layers

## Other bits

* Benjamin Moss wrote an article on [Predicting fuel efficiency with Elixir, Nx, and Axon: a gentle introduction to Machine Learning](https://bitfield.co/posts/machine-learning-in-elixir-with-nx-and-axon/)

* Dmitry Rubinstein has implemented [a Jupyter backend for Elixir](https://github.com/spawnfest/ielixir) during this year's [Spawnfest](https://spawnfest.org)

* Robert Bates has shared a presentation about [AI packages for Elixir currently available on Hex.pm](https://docs.google.com/presentation/d/1_GiJ32hv3mv1qBHlZHkLH-GiSlrNTvObBnAPRoagm00/edit#slide=id.gc6f73a04f_0_46)

Are you also interested in Machine Learning and the Erlang Ecosystem? [Join us and come chat on our Slack](https://erlef.org/wg/machine-learning).
