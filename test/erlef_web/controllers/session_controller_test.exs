defmodule ErlefWeb.SessionControllerTest do
  use ErlefWeb.ConnCase

  test "GET /login", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :show))
    assert html_response(conn, 200) =~ "Log in"
    assert html_response(conn, 200) =~ "Username or Email"
  end

  describe "POST /login" do
    test "as a member", %{conn: conn} do
      params = %{
        "username" => "member@erlef.test",
        "g-recaptcha-response" => "valid",
        "password" => "hunter42"
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(conn, redir_path)
      refute html_response(conn, 200) =~ "Log in"
      assert html_response(conn, 200) =~ "Log out"
    end

    test "as an admin", %{conn: conn} do
      params = %{
        "username" => "admin@erlef.test",
        "g-recaptcha-response" => "valid",
        "password" => "hunter42"
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(conn, redir_path)
      refute html_response(conn, 200) =~ "Log in"
      assert html_response(conn, 200) =~ "Admin"
      assert html_response(conn, 200) =~ "Log out"
    end

    test "with invalid recaptcha response", %{conn: conn} do
      params = %{
        "username" => "admin@erlef.test",
        "g-recaptcha-response" => "invalid",
        "password" => "hunter42"
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert html_response(conn, 200) =~ "Invalid Login"
    end

    test "with an invalid username", %{conn: conn} do
      params = %{
        "username" => "not_an_email",
        "g-recaptcha-response" => "valid",
        "password" => "hunter42"
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert html_response(conn, 200) =~ "Invalid Login"
    end

    test "with no params", %{conn: conn} do
      params = %{}

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert html_response(conn, 200) =~ "Invalid Login"
    end
  end

  describe "POST /logout" do
    test "as a member", %{conn: conn} do
      params = %{
        "username" => "member@erlef.test",
        "g-recaptcha-response" => "valid",
        "password" => "hunter42"
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(conn, redir_path)
      refute html_response(conn, 200) =~ "Log in"
      assert html_response(conn, 200) =~ "Log out"
      conn = post(conn, Routes.session_path(conn, :delete))
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(conn, redir_path)
      assert html_response(conn, 200) =~ "Log in"
      refute html_response(conn, 200) =~ "Log out"
    end

    test "as an admin", %{conn: conn} do
      params = %{
        "username" => "member@erlef.test",
        "g-recaptcha-response" => "valid",
        "password" => "hunter42"
      }

      conn = post(conn, Routes.session_path(conn, :create), params)
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(conn, redir_path)
      refute html_response(conn, 200) =~ "Log in"
      assert html_response(conn, 200) =~ "Log out"
      conn = post(conn, Routes.session_path(conn, :delete))
      assert "/" = redir_path = redirected_to(conn, 302)
      conn = get(conn, redir_path)
      assert html_response(conn, 200) =~ "Log in"
      refute html_response(conn, 200) =~ "Log out"
      refute html_response(conn, 200) =~ "Admin"
    end
  end
end
