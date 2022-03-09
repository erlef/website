defmodule Erlef.Groups.GitReport do
  @moduledoc false

  # n.b, 
  # This is the initial implementation of a concept called GitReport. 
  # This however is not a good abstraction. A proper absaction would would not be confined to reports.
  # More features of the app will make use git for submitting and updating files and a 
  # proper abstraction should emerge after more cases. Make it work! :tm:

  alias Erlef.Groups.WorkingGroupReport

  alias Erlef.Github

  def get_status(%WorkingGroupReport{} = report) do
    args = %{
      report: report,
      repo: report_repo(report),
      pull_number: report_pull_number(report)
    }

    with {:ok, state} <- to_state(args),
         {:ok, state} <- get_token(state),
         {:ok, state} <- get_pr_status(state) do
      case state.pull_request_status == report.status do
        true -> {:ok, report.status}
        false -> {:changed, state.pull_request_status}
      end
    end
  end

  def submit(%WorkingGroupReport{} = report) do
    case Erlef.is_env?(:prod) do
      true ->
        args = %{
          files: report_to_files(report),
          from: branch_name(report),
          to: "main",
          title: report_title(report),
          description: report_description(report),
          repo: report_repo(report),
          author: report_author(report),
          message: report_title(report)
        }

        create(args)

      false ->
        # N.B, a sub-sequent PR must be done to support faking github in order
        # to avoid this temp hack
        {:ok, %{}}
    end
  end

  def update(%WorkingGroupReport{} = report) do
    case Erlef.is_env?(:prod) do
      true ->
        args = %{
          files: report_to_existing_files(report),
          repo: report_repo(report),
          message: report.update_message,
          branch_name: branch_name(report),
          from: branch_name(report),
          author: report_author(report),
          last_commit_sha: report_last_commit(report),
          pull_number: report_pull_number(report)
        }

        case do_update(args) do
          {:ok, state} ->
            meta =
              report.meta
              |> put_in(["source", "pull_request"], state.pull_request)
              |> put_in(["source", "branch"], state.branch)

            {:ok, meta}

          err ->
            err
        end

      false ->
        # N.B, a sub-sequent PR must be done to support faking github in order
        # to avoid this temp hack
        {:ok, report.meta}
    end
  end

  def create(args) do
    with {:ok, state} <- to_state(args),
         {:ok, state} <- get_token(state),
         {:ok, state} <- get_last_commit(state),
         {:ok, state} <- create_files(state),
         {:ok, state} <- create_commit(state),
         {:ok, state} <- create_branch(state),
         {:ok, state} <- create_pr(state) do
      meta = %{
        source: %{
          type: "git",
          provider: "github",
          params: args,
          pull_request: state.pull_request,
          branch: state.branch,
          commit: state.commit,
          tree: state.tree
        }
      }

      {:ok, meta}
    end
  end

  defp do_update(args) do
    with {:ok, state} <- to_state(args),
         {:ok, state} <- get_token(state),
         {:ok, state} <- create_files(state),
         {:ok, state} <- create_commit(state),
         {:ok, state} <- update_branch(state) do
      get_pr(state)
    end
  end

  defp get_pr(state) do
    p = %{owner: state.owner, repo: state.repo, number: state.pull_number}

    case Github.get_pr(state.token, p) do
      {:ok, pr} ->
        {:ok, set(state, :pull_request, pr)}

      err ->
        err
    end
  end

  defp get_pr_status(state) do
    p = %{owner: state.owner, repo: state.repo, number: state.pull_number}

    case Github.get_pr_status(state.token, p) do
      {:ok, status} ->
        {:ok, set(state, :pull_request_status, status)}

      err ->
        err
    end
  end

  defp get_token(state) do
    case Github.auth_app() do
      {:ok, token} ->
        {:ok, set(state, :token, token)}

      err ->
        err
    end
  end

  defp get_last_commit(state) do
    p = %{owner: state.owner, repo: state.repo}

    case Github.get_main_last_commit(state.token, p) do
      {:ok, last_commit} ->
        state =
          state
          |> set(:last_commit_sha, last_commit["sha"])
          |> set(:last_commit, last_commit)

        {:ok, state}

      err ->
        err
    end
  end

  defp create_files(state) do
    p = %{
      owner: state.owner,
      repo: state.repo,
      files: state.files,
      base_tree: state.last_commit_sha
    }

    case Github.create_files(state.token, p) do
      {:ok, tree} ->
        state =
          state
          |> set(:tree_sha, tree["sha"])
          |> set(:tree, tree)

        {:ok, state}

      err ->
        err
    end
  end

  defp create_commit(state) do
    p = %{
      owner: state.owner,
      repo: state.repo,
      files: state.tree,
      author: state.author,
      message: state.message,
      tree: state.tree_sha,
      parents: [state.last_commit_sha]
    }

    case Github.create_commit(state.token, p) do
      {:ok, commit} ->
        state =
          state
          |> set(:commit_sha, commit["sha"])
          |> set(:commit, commit)

        {:ok, state}

      err ->
        err
    end
  end

  defp create_branch(state) do
    p = %{
      owner: state.owner,
      repo: state.repo,
      name: state.from,
      sha: state.commit_sha
    }

    case Github.create_branch(state.token, p) do
      {:ok, branch} ->
        {:ok, set(state, :branch, branch)}

      err ->
        err
    end
  end

  defp update_branch(state) do
    p = %{
      owner: state.owner,
      repo: state.repo,
      name: state.from,
      sha: state.commit_sha
    }

    case Github.update_branch(state.token, p) do
      {:ok, branch} ->
        {:ok, set(state, :branch, branch)}

      err ->
        err
    end
  end

  defp create_pr(state) do
    p = %{
      maintainer_can_modify: true,
      body: state.description,
      head: "refs/heads/#{state.from}",
      base: "refs/heads/#{state.to}",
      owner: state.owner,
      repo: state.repo,
      title: state.title
    }

    case Github.create_pr(state.token, p) do
      {:ok, pr} ->
        {:ok, set(state, :pull_request, pr)}

      err ->
        err
    end
  end

  defp timestamp(dt), do: Calendar.strftime(dt, "%Y-%m-%d-%H%M%S")

  defp branch_name(%{meta: %{"source" => %{"params" => %{"from" => from}}}}), do: from

  defp branch_name(report) do
    "#{report.working_group.slug}-#{report.type}-report-#{timestamp(report.inserted_at)}"
  end

  defp report_author(%{meta: %{"source" => %{"params" => %{"author" => author}}}}), do: author

  defp report_author(report) do
    %{name: report.submitted_by.name, email: "erlef.bot@erlef.org"}
  end

  defp report_description(%WorkingGroupReport{type: :quarterly} = report) do
    """
    # Quarterly report for #{report.working_group.name} working group 

    ## Submitted by - #{report.submitted_by.name}
    """
  end

  defp report_title(report) do
    "#{report.working_group.name} - #{report.type} report"
  end

  defp report_repo(_) do
    config = Application.get_env(:erlef, :reports)
    Keyword.get(config, :report_submission_repo)
  end

  defp report_to_files(report) do
    slug = report.working_group.slug
    ts = timestamp(report.inserted_at)
    path = "reports/#{slug}/quarterly/#{slug}-#{ts}.md"

    [
      %{
        content: report.content,
        path: path
      }
    ]
  end

  defp report_to_existing_files(report) do
    [file] = report.meta["source"]["params"]["files"]

    [
      %{
        content: report.content,
        path: file["path"]
      }
    ]
  end

  defp report_pull_number(report) do
    report.meta["source"]["pull_request"]["number"]
  end

  defp report_last_commit(%{meta: %{"source" => %{"branch" => %{"sha" => sha}}}}) do
    sha
  end

  defp set(state, key, val), do: Map.put(state, key, val)

  defp to_state(%{repo: repo} = args) do
    case String.split(repo, "/") do
      [owner, gh_repo] ->
        state =
          args
          |> set(:owner, owner)
          |> set(:repo, gh_repo)

        {:ok, state}

      _ ->
        {:error, "Malformed owner/repo value"}
    end
  end
end
