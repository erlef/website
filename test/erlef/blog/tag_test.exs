defmodule Erlef.Blog.TagTest do
  use ExUnit.Case

  alias Erlef.Blog.Tag

  @test_data %{
    name: "Sample tag"
  }

  describe "changeset/2" do
    test "returns a valid changeset when required fields present" do
      assert %{valid?: true, errors: []} = Tag.changeset(%Tag{}, @test_data)
    end

    test "returns an invalid changeset when missing required fields" do
      assert %{valid?: false, errors: errors} = Tag.changeset(%Tag{}, %{})

      assert errors == [
               name: {"can't be blank", [validation: :required]}
             ]
    end

    test "returns a changeset with a slug based on the name" do
      %{changes: %{slug: slug}} = Tag.changeset(%Tag{}, @test_data)

      assert ^slug = Slug.slugify(@test_data.name)
    end
  end
end
