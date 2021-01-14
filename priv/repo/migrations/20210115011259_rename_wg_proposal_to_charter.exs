defmodule Erlef.Repo.Migrations.RenameWgProposalToCharter do
  use Ecto.Migration

  def change do
    rename table(:working_groups), :proposal, to: :charter
    rename table(:working_groups), :proposal_html, to: :charter_html
  end
end
