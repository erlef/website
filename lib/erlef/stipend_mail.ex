defmodule Erlef.StipendMail do
  @moduledoc """
  Erlef.StipendMail
  """

  import Swoosh.Email

  use Phoenix.Swoosh, view: ErlefWeb.EmailView, layout: {ErlefWeb.LayoutView, :email}

  @spec submission(Erlef.StipendProposal.t()) :: Swoosh.Email.t()
  def submission(proposal) do
    dt_str = DateTime.utc_now() |> DateTime.truncate(:second)

    subject_suffix = "on #{dt_str} via #{full_name(proposal)} (#{proposal.email_address}"

    new()
    |> recipients(proposal.stipend_type)
    |> from({"EEF Stipend Submissions", "notifications@erlef.org"})
    |> subject("EEF Stipend Proposal Submission #{subject_suffix}")
    |> attach_files(email, proposal.files)
    |> render_body("stipend_submission.html", proposal: proposal, copy: false)
  end

  defp recipients(email, "Elixir Outreach") do
    to(email, {"Elixir Outreach Stipend Committee", "elixir_outreach@erlef.org"})
  end

  defp recipients(email, _) do
    email
    |> to({"eef-stipends", "eef-stipends@googlegroups.com"})
    |> bcc({"eef-stipends", "stipends@erlef.org"})
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
