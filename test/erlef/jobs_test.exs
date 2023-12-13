defmodule Erlef.JobsTest do
  use Erlef.DataCase

  alias Erlef.Jobs
  alias Erlef.Jobs.Error

  @valid_attrs %{
    "title" => "Junior Elixir Developer",
    "description" => "Some short description",
    "position_type" => "permanent",
    "website" => "https://google.com"
  }

  @invalid_attrs %{
    "description" => "Some short description",
    "position_type" => "permanent"
  }

  defmacro dotimes(times, do: body) do
    quote do
      for _ <- 0..(unquote(times) - 1) do
        unquote(body)
      end
    end
  end

  describe "get_post!/1" do
    test "retrieves a post by id" do
      member = insert_member!("basic_member")
      {:ok, %{id: id}} = Jobs.create_post(member, @valid_attrs)

      assert %Jobs.Post{id: ^id} = Jobs.get_post!(id)
    end
  end

  describe "create_post/2" do
    test "creates a post with valid attributes" do
      member = insert_member!("basic_member")

      assert {:ok, %Jobs.Post{}} = Jobs.create_post(member, @valid_attrs)
    end

    test "preloads correct values ofter creation" do
      %{id: sponsor_id} = insert!(:sponsor)
      member = insert_member!("sponsored_member", sponsor_id: sponsor_id)

      assert {:ok, %Jobs.Post{} = post} = Jobs.create_post(member, @valid_attrs)
      assert post.updated_by
      assert post.sponsor_id
    end

    test "returns error tuple if attributes are invalid" do
      member = insert_member!("basic_member")

      {:error, %Error{reason: {:changeset, cs}}} = Jobs.create_post(member, @invalid_attrs)

      refute cs.valid?
      assert "can't be blank" in errors_on(cs).title
    end

    test "returns error tuple if author has reached posts limit" do
      member = insert_member!("basic_member")

      dotimes 4 do
        {:ok, _} = Jobs.create_post(member, @valid_attrs)
      end

      assert {:error, %Error{reason: :post_quota_reached}} =
               Jobs.create_post(member, @valid_attrs)
    end

    test "returns error tuple if author's sponsor has reached posts limit" do
      %{id: sponsor_id} = insert!(:sponsor)
      member1 = insert_member!("sponsored_member", sponsor_id: sponsor_id)

      dotimes 4 do
        {:ok, _} = Jobs.create_post(member1, @valid_attrs)
      end

      member2 =
        insert_member!("sponsored_member", id: Ecto.UUID.generate(), sponsor_id: sponsor_id)

      assert {:error, %Error{reason: :post_quota_reached}} =
               Jobs.create_post(member2, @valid_attrs)
    end
  end

  describe "update_post/2" do
    test "updates a post with valid attributes" do
      member = insert_member!("basic_member")
      {:ok, %{approved: false} = post} = Jobs.create_post(member, @valid_attrs)

      assert {:ok, %{approved: true}} = Jobs.update_post(member, post, %{approved: true})
    end

    test "returns error tuple if update attributes are invalid" do
      member = insert_member!("basic_member")
      {:ok, post} = Jobs.create_post(member, @valid_attrs)

      assert {:error, %Error{reason: {:changeset, cs}}} =
               Jobs.update_post(member, post, %{website: "test123"})

      refute cs.valid?
      assert "is missing a scheme (e.g. https)" in errors_on(cs).website
    end

    test "returns error tuple if user is not an owner" do
      member = insert_member!("basic_member")
      {:ok, post} = Jobs.create_post(member, @valid_attrs)
      updater = insert_member!("basic_member")

      assert {:error, %Error{reason: :unauthorized}} =
               Jobs.update_post(updater, post, %{approved: true})
    end

    test "returns error tuple if user's sponsor is not an owner" do
      %{id: sponsor_id} = insert!(:sponsor)
      member1 = insert_member!("sponsored_member", sponsor_id: sponsor_id)
      {:ok, post} = Jobs.create_post(member1, @valid_attrs)

      %{id: other_sponsor_id} = insert!(:sponsor)

      member2 =
        insert_member!("sponsored_member", id: Ecto.UUID.generate(), sponsor_id: other_sponsor_id)

      assert {:error, %Error{reason: :unauthorized}} =
               Jobs.update_post(member2, post, %{approved: true})
    end
  end

  describe "approve_post/2" do
    test "sets approved field to true" do
      member = insert_member!("basic_member")
      {:ok, %Jobs.Post{approved: false} = post} = Jobs.create_post(member, @valid_attrs)
      admin = insert_member!("admin")
      {:ok, post} = Jobs.approve_post(admin, post)

      assert %Jobs.Post{approved: true} = post
    end

    test "returns error tuple if non-admin tries to approve post" do
      member = insert_member!("basic_member")
      {:ok, %Jobs.Post{approved: false} = post} = Jobs.create_post(member, @valid_attrs)

      assert {:error, %Error{reason: :unauthorized}} = Jobs.approve_post(member, post)
    end
  end
end
