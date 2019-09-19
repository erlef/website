defmodule Erlef.GrantMail do
  @moduledoc """
  Erlef.GrantMail
  """

  import Swoosh.Email

  use Phoenix.Swoosh, view: ErlefWeb.EmailView, layout: {ErlefWeb.LayoutView, :email}

  @spec submission(%Erlef.GrantProposal{}) :: %Swoosh.Email{}
  def submission(proposal) do
    dt_str = DateTime.to_string(DateTime.utc_now())

    subject_suffix = "on #{dt_str} via #{full_name(proposal)} (#{proposal.email_address}"

    email =
      new()
      |> to({"eef-grants", "eef-grants@googlegroups.com"})
      |> from({"EEF Grant Submissions", "eef-grant-submissions@beam.eco"})
      |> subject("EEF Grant Proposal Submission #{subject_suffix}")

    new_email = attach_files(email, proposal.files)
    render_body(new_email, "grant_submission.html", proposal: proposal, copy: false)
  end

  def submission_copy(proposal) do

    email =
      new()
      |> to({full_name(proposal), proposal.email_address})
      |> from({"EEF Grant Submissions", "eef-grant-submissions@beam.eco"})
      |> subject("EEF Grant Proposal Copy")

    new_email = attach_files(email, proposal.files)
    render_body(new_email, "grant_submission.html", proposal: proposal, copy: true)
  end

  defp attach_files(email, nil), do: email
  defp attach_files(email, []), do: email

  defp attach_files(email, files) do
    Enum.reduce(files, email, fn f, acc ->
      attachment(acc, f)
    end)
  end

  defp full_name(proposal) do 
    "#{proposal.first_name} #{proposal.last_name}"
  end
end
