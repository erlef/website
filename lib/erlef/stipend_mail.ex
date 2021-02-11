defmodule Erlef.StipendMail do
  @moduledoc """
  Erlef.StipendMail
  """

  import Swoosh.Email

  use Phoenix.Swoosh, view: ErlefWeb.EmailView, layout: {ErlefWeb.LayoutView, :email}

  @spec submission(%Erlef.StipendProposal{}) :: %Swoosh.Email{}
  def submission(proposal) do
    dt_str = DateTime.utc_now() |> DateTime.truncate(:second)

    subject_suffix = "on #{dt_str} via #{full_name(proposal)} (#{proposal.email_address}"

    email =
      new()
      |> to({"eef-stipends", "eef-stipends@googlegroups.com"})
      |> from({"EEF Stipend Submissions", "notifications@erlef.org"})
      |> subject("EEF Stipend Proposal Submission #{subject_suffix}")

    new_email = attach_files(email, proposal.files)
    render_body(new_email, "stipend_submission.html", proposal: proposal, copy: false)
  end

  def submission_copy(proposal) do
    email =
      new()
      |> to({full_name(proposal), proposal.email_address})
      |> from({"EEF Stipend Submissions", "notifications@erlef.org"})
      |> subject("EEF Stipend Proposal Copy")

    new_email = attach_files(email, proposal.files)
    render_body(new_email, "stipend_submission.html", proposal: proposal, copy: true)
  end

  defp attach_files(email, nil), do: email
  defp attach_files(email, []), do: email

  defp attach_files(email, files) do
    only_plugs =
      Enum.filter(files, fn f ->
        case f do
          %Plug.Upload{} -> true
          _ -> false
        end
      end)

    Enum.reduce(only_plugs, email, fn f, acc ->
      attachment(acc, f)
    end)
  end

  defp full_name(proposal) do
    "#{proposal.first_name} #{proposal.last_name}"
  end
end
