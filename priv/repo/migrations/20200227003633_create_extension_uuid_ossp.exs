defmodule Erlef.Data.Repo.Migrations.CreateExtensionUuidOssp do
  use Ecto.Migration

  def up do
    execute """
    CREATE EXTENSION "uuid-ossp";
    """
  end

  def down do
    execute """
    DROP EXTENSION "uuid-ossp";
    """
  end
end
