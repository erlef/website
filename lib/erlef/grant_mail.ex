defmodule Erlef.GrantMail do
  import Swoosh.Email

  use Phoenix.Swoosh, view: ErlefWeb.EmailView, layout: {ErlefWeb.LayoutView, :email}

  def submission(proposal) do
    email =
      new()
      |> to({"eef-grants", "eef-grants@googlegroups.com"})
      |> from({"EEF Grant Submissions", "eef-grant-submissions@beam.eco"})
      |> subject("EEF Grant Proposal Submission")

    new_email =
      Enum.reduce(proposal.files, email, fn {k, v}, acc ->
        attachment(acc, v)
      end)

    render_body(new_email, "grant_submission.html", proposal: proposal, copy: false)
  end

  def submission_copy(proposal) do
    full_name = "#{proposal.first_name} #{proposal.last_name}"

    email =
      new()
      |> to({full_name, proposal.email_address})
      |> from({"EEF Grant Submissions", "eef-grant-submissions@beam.eco"})
      |> subject("EEF Grant Proposal Copy")

    new_email =
      Enum.reduce(proposal.files, email, fn {k, v}, acc ->
        attachment(acc, v)
      end)

    render_body(new_email, "grant_submission.html", proposal: proposal, copy: true)
  end
end
