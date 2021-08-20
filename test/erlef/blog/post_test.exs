defmodule Erlef.Blog.PostTest do
  use ExUnit.Case

  alias Erlef.Blog.Post

  @test_data %{
    title: "How to test",
    body: "This is how",
    status: :draft,
    member_id: 12
  }

  describe "changeset/2" do
    test "returns a valid changeset when required fields present" do
      assert %{valid?: true, errors: []} = Post.changeset(%Post{}, @test_data)
    end

    test "returns an invalid changeset when missing required fields" do
      assert %{valid?: false, errors: errors} = Post.changeset(%Post{}, %{})

      assert errors == [
               title: {"can't be blank", [validation: :required]},
               body: {"can't be blank", [validation: :required]},
               status: {"can't be blank", [validation: :required]},
               member_id: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns a changeset with a slug based on the title" do
      %{changes: %{slug: slug}} = Post.changeset(%Post{}, @test_data)

      assert ^slug = Slug.slugify(@test_data.title)
    end

    test "returns a valid changeset for valid status values" do
      for valid_status <- [:draft, :published, :archived] do
        assert %{valid?: true, errors: []} =
                 Post.changeset(%Post{}, Map.put(@test_data, :status, valid_status))
      end
    end

    test "returns an invalid changeset for invalid status" do
      assert %{valid?: false, errors: [status: {"is invalid", _type}]} =
               Post.changeset(%Post{}, Map.put(@test_data, :status, :invalid_status))
    end
  end
end
