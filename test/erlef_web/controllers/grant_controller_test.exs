defmodule ErlefWeb.GrantControllerTest do
  use ErlefWeb.ConnCase

  test "GET /grants", %{conn: conn} do
    conn = get(conn, Routes.grant_path(conn, :index))
    assert html_response(conn, 200) =~ "Grant request process"
  end

  describe "POST /grants" do
    test "with valid params", %{conn: conn} do
      params = %{
        beneficiaries: "A bit about beneficiaries",
        bio: "A bit about myself",
        city: "Castle Rock",
        code_of_conduct_link: "https://codeofconduct.tld/path",
        country: "United States",
        email_address: "grantee@want-a-grant.org",
        first_name: "Firstname",
        grant_amount: "1,000,000.00",
        grant_type: "Development Work",
        last_name: "Lastname",
        linkedin: "https://linkedin.com/user124",
        nick_name: "hmm",
        org_email: "org_email@someorg.org",
        org_name: "Org Name",
        payment_method: "paypal",
        phone_number: "+1555123456",
        postal_code: "12345",
        purpose: "To do things",
        region: "Maine",
        report: "How I plan on reporting expenses...",
        twitter: "https://twitter.com/foo",
        website: "https://epic-site.org/"
      }

      upload = %Plug.Upload{path: "test/support/sample.pdf", filename: "sample.pdf"}
      conn = post(conn, Routes.grant_path(conn, :create, params), files: [upload])
      assert html_response(conn, 200) =~ "Expect a copy of your grant proposal"
    end

    test "with invalid size name param", %{conn: conn} do
      params = %{
        beneficiaries: "A bit about beneficiaries",
        bio: "A bit about myself",
        city: "Castle Rock",
        code_of_conduct_link: "https://codeofconduct.tld/path",
        country: "United States",
        email_address: "grantee@want-a-grant.org",
        first_name: "Hubert Blaine Wolfeschlegelsteinhausenbergerdorff Sr.",
        grant_amount: "1,000,000.00",
        grant_type: "Development Work",
        last_name: "Lastname",
        linkedin: "https://linkedin.com/user124",
        nick_name: "hmm",
        org_email: "org_email@someorg.org",
        org_name: "Org Name",
        payment_method: "paypal",
        phone_number: "+1555123456",
        postal_code: "12345",
        purpose: "To do things",
        region: "Maine",
        report: "How I plan on reporting expenses...",
        twitter: "https://twitter.com/foo",
        website: "https://epic-site.org/"
      }

      upload = %Plug.Upload{path: "test/support/sample.pdf", filename: "sample.pdf"}
      conn = post(conn, Routes.grant_path(conn, :create, params), files: [upload])
      assert html_response(conn, 200) =~ "invalid first_name - max size 50"
    end
  end
end
