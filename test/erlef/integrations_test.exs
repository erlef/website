defmodule Erlef.IntegrationsTest do
  use Erlef.DataCase

  alias Erlef.Integrations

  describe "apps" do
    alias Erlef.Integrations.App

    @audit_opts [audit: %{member_id: Ecto.UUID.generate()}]
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def app_fixture(attrs \\ %{}) do
      {:ok, app} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Integrations.create_app(@audit_opts)

      app
    end

    test "list_apps/0 returns all apps" do
      app = app_fixture()
      assert Integrations.list_apps() == [app]
    end

    test "get_app!/1 returns the app with given id" do
      app = app_fixture()
      assert Integrations.get_app!(app.id) == app
    end

    test "create_app/1 with valid data creates a app" do
      assert {:ok, %App{} = app} = Integrations.create_app(@valid_attrs, @audit_opts)
      assert app.name == "some name"
    end

    test "create_app/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_app(@invalid_attrs, @audit_opts)
    end

    test "update_app/2 with valid data updates the app" do
      app = app_fixture()
      assert {:ok, %App{} = app} = Integrations.update_app(app, @update_attrs, @audit_opts)
      assert app.name == "some updated name"
    end

    test "update_app/2 with invalid data returns error changeset" do
      app = app_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Integrations.update_app(app, @invalid_attrs, @audit_opts)

      assert app == Integrations.get_app!(app.id)
    end
  end
end
