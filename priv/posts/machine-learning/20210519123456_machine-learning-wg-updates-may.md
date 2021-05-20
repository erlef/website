{
  "title": "Machine Learning WG updates - May 2021",
  "authors": ["The Machine Learning WG"],
  "slug": "machine-learning-updates-may-2021",
  "tags": ["machine learning", "axon", "nx", "livebook", "scidata"],
  "category": "machine-learning",
  "datetime": "2021-05-19T12:34:56.921505Z"
}
---
Machine Learning WG updates - May 2021
---

The Erlang Ecosystem Foundation has recently announced the Machine Learning Working Group which is working on bringing Numerical Computing and Machine Learning libraries to the Erlang Ecosystem.
The working group has enjoyed tremendous growth in the last months and today we want to share what we have accomplished in the last 30 days or so.

## Nx updates

[Nx](https://github.com/elixir-nx/nx) is a multi-dimensional arrays (tensors) library with multi-staged compilation to the CPU/GPU.

*   It is now possible to slice a tensor based on dynamic indexes, allowing you to access a tensor position based on the value of another tensor. `Nx.put_slice/3` has also been added, which allows you to update part of a tensor with another tensor, statically or dynamically (see [pull request](https://github.com/elixir-nx/nx/pull/400))

*   Numerical definitions now support while loops. This is important as it allows the whole training loop to run in the GPU without back and forth with host (see [pull request](https://github.com/elixir-nx/nx/pull/390))

*   Maps are now supported in numerical definitions. For models that had too many parameters, the positional aspect of tuples were too cumbersome. Using maps give developers more flexibility to work with complex models (see [pull request](https://github.com/elixir-nx/nx/pull/406)) \

*   New functions such as Nx.argsort/2 (see [pull request](https://github.com/elixir-nx/nx/pull/367)) and Nx.stack/2 ([pull request](https://github.com/elixir-nx/nx/pull/380)) have been added

*   Work has started on built-in support for vmap, also known as auto-vectorization. Some operations, such as the dot product, have already been extended to support batching

## Axon updates

[Axon](https://github.com/elixir-nx/axon/) is a library led by Sean Moriarity that brings deep learning to the Erlang Ecosystem. It is powered by Nx and runs on the CPU/GPU.

*   Axon now supports recurrent layers (`Axon.lstm/3`, `Axon.gru/3`, `Axon.conv_lstm/3`) with the option to dynamically or statically unroll layers over an entire sequence

*   Axon now handles multi-input / multi-output models for accepting data in multiple places and returning multiple predictions from a common model

*   Axon now ships with parameter regularization via `Axon.penalty/3` and regularizer options passed to individual layers

*   Axon now provides custom layers via the `Axon.layer/5` method. You can specify your own trainable parameters, and implement your layer as a numerical definition

*   Axon’s training API supports training from an initial model state, this is useful for transfer learning and some reinforcement learning applications

*   We are in the process of migrating Axon’s examples to Livebooks. See the [MNIST Livebook example](https://github.com/elixir-nx/axon/blob/main/notebooks/mnist.livemd).  We are accepting PRs for [additional examples](https://github.com/elixir-nx/axon/issues/47) as well as for [converting examples to live markdown](https://github.com/elixir-nx/axon/issues/52). Both issues are a great way to get involved with the project and to learn about Axon!

## Livebook updates

[Livebook](https://github.com/elixir-nx/livebook/) is a collaborative and interactive code notebook maintained by Jonatan Kłosko.

*   Livebook was announced last month. [Watch the original announcement by José Valim](https://www.youtube.com/watch?v=RKvqc-UEe34)

*   After the announcement, new features have been added, such as autocompletion of Elixir code ([watch an example](https://user-images.githubusercontent.com/17034772/115117125-533b2900-9f9d-11eb-94a9-a2cf2ccb7388.mp4)) and an embedded mode that is useful for running on Nerves devices

*   Most recently, Livebook got user collaboration, which gives each user an avatar and allows you to see all users in a notebook and what they are currently editing ([watch an example](https://user-images.githubusercontent.com/17034772/117443192-15944500-af38-11eb-9f70-618975c2f28c.mp4))

*   Official Livebook Docker images have also been published, all you need to get started is to run: `docker run -p 8080:8080 livebook/livebook`

*   Users can also import notebooks from a URL, so trying out notebooks from GitHub or Gist is extremely straightforward. You can already get some examples from [here](https://github.com/elixir-nx/axon/tree/main/notebooks) and [here](https://github.com/jonatanklosko/notebooks)

## Scidata updates

Last month we also announced [Scidata](https://github.com/elixir-nx/scidata), a library by Tom Rutten for downloading and normalizing data sets related to science.

*   Scidata currently supports MNIST, FashionMNIST, CIFAR10 and CIFAR100 data sets

*   We welcome PRs for additional vision and [text data sets](https://github.com/elixir-nx/scidata/issues/11)!

## Tweets and other bits

Here is a collection of fun stuff people are doing with the existing libraries and with machine learning on the BEAM:

*   [Masatoshi Nishiguchi wrote a Livebook document that controls a BMP280 temperature sensor that is connected to a Raspberry Pi](https://twitter.com/MNishiguchiDC/status/1390658051267563520)

*   [Marcelo Reichert used Axon to simulate an autonomous car finding its objective](https://twitter.com/marceloreichert/status/1385427566278975491)

*   [Jonatan Kłosko was on the ThinkingElixir podcast to talk about Livebook and its implementation](https://thinkingelixir.com/podcast-episodes/046-livebook-with-jonatan-klosko/)

*   [José Valim was on the Changelog podcast talking about Machine Learning and the Erlang Ecosystem](https://changelog.com/podcast/439)

*   [Jorge Garrido has released a library for interfacing with Python data science libraries directly from Erlang](https://github.com/zgbjgg/jun)

*   [Robert Bates wrote a DQN with Axon to solve the Cartpole environment from OpenAI’s Gym](https://twitter.com/sean_moriarity/status/1381968449069441031)

*   [Bruce Tate has released an introductory video to Nx and Axon where they predict the XOR operator](https://www.youtube.com/watch?v=NcsqGS6SVXg)

Are you also interested in Machine Learning and the Erlang Ecosystem? [Join us and come chat on our Slack](https://erlef.org/wg/machine-learning).
