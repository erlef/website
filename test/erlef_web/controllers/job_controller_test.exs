defmodule ErlefWeb.JobControllerTest do
  use ErlefWeb.ConnCase

  alias Erlef.Jobs

  @valid_attrs %{
    "title" => "Junior Elixir Developer",
    "description" => "Some short description",
    "position_type" => "permanent",
    "website" => "http://google.com"
  }

  @invalid_attrs %{
    "description" => "Some short description",
    "position_type" => "permanent",
    "approved" => "true"
  }

  defmacro dotimes(times, do: body) do
    quote do
      for _ <- 0..(unquote(times) - 1) do
        unquote(body)
      end
    end
  end

  describe "show/2" do
    setup :basic_session

    test "returns not found when post is not approved", %{conn: conn} do
      author = insert_member!("basic_member")
      attrs = Map.put(@valid_attrs, "approved", "false")
      {:ok, post} = Jobs.create_post(author, attrs)

      _ =
        conn
        |> get(Routes.job_path(conn, :show, post.id))
        |> html_response(404)
    end
  end

  describe "new/2" do
    setup :basic_session

    test "redirects to index when posts limit is reached", %{
      current_user: current_user,
      conn: conn
    } do
      dotimes 4 do
        {:ok, _} = Jobs.create_post(current_user, @valid_attrs)
      end

      conn = get(conn, Routes.job_path(conn, :new))

      assert redirected_to(conn) == "/"
    end
  end

  describe "create/2" do
    setup :basic_session

    test "redirects to index when posts limit is reached", %{
      current_user: current_user,
      conn: conn
    } do
      dotimes 4 do
        {:ok, _} = Jobs.create_post(current_user, @valid_attrs)
      end

      conn = get(conn, Routes.job_path(conn, :new))

      assert redirected_to(conn) == "/"
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.job_path(conn, :create), post: @valid_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.job_path(conn, :show, id)

      response =
        conn
        |> get(Routes.job_path(conn, :show, id))
        |> html_response(200)

      assert response =~ "Junior Elixir Developer"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.job_path(conn, :create), post: @invalid_attrs)
        |> html_response(200)

      assert response =~ "Creating Post"
    end
  end

  describe "edit/2" do
    setup :basic_session

    test "returns not found when the user is not the post's owner", %{conn: conn} do
      author = insert_member!("basic_member")
      {:ok, post} = Jobs.create_post(author, @valid_attrs)

      assert_error_sent 404, fn ->
        get(conn, Routes.job_path(conn, :edit, post.id))
      end
    end

    test "returns not found when the user's sponsor is not the post's owner", %{conn: conn} do
      %{id: sponsor_id} = insert!(:sponsor)
      author = insert_member!("sponsored_member", sponsor_id: sponsor_id)
      {:ok, post} = Jobs.create_post(author, @valid_attrs)

      assert_error_sent 404, fn ->
        get(conn, Routes.job_path(conn, :edit, post.id))
      end
    end
  end

  describe "update/2" do
    setup :basic_session

    test "returns not found when the user is not the post's owner", %{conn: conn} do
      author = insert_member!("basic_member")
      {:ok, post} = Jobs.create_post(author, @valid_attrs)

      assert_error_sent 404, fn ->
        put(conn, Routes.job_path(conn, :update, post.id), post: %{"title" => "a new title"})
      end
    end

    test "returns not found when the user's sponsor is not the post's owner", %{conn: conn} do
      %{id: sponsor_id} = insert!(:sponsor)
      author = insert_member!("sponsored_member", sponsor_id: sponsor_id)
      {:ok, post} = Jobs.create_post(author, @valid_attrs)

      assert_error_sent 404, fn ->
        put(conn, Routes.job_path(conn, :update, post.id), post: %{"title" => "a new title"})
      end
    end
  end
end
