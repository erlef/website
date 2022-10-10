defmodule Erlef.Jobs do
  @moduledoc """
  The Jobs context.
  """

  alias Ecto.Changeset
  alias Erlef.Repo
  alias __MODULE__.Error
  alias Erlef.Jobs.Post
  alias Erlef.Jobs.PostHistoryEntry
  alias Erlef.Accounts.Member

  import Ecto.Query

  @max_posts_per_author 4

  @type create_post_params :: %{
          title: String.t(),
          description: String.t(),
          position_type: :permanent | :contractor,
          city: String.t() | nil,
          region: String.t() | nil,
          country: String.t() | nil,
          remote: boolean(),
          website: URI.t(),
          days_to_live: pos_integer() | nil
        }

  @type update_post_params :: %{
          title: String.t(),
          description: String.t(),
          approved: boolean(),
          position_type: :permanent | :contractor,
          city: String.t() | nil,
          region: String.t() | nil,
          country: String.t() | nil,
          remote: boolean(),
          website: URI.t()
        }

  @doc """
  Retrieves all job posts which are approved and not expired.

  Sposored posts are in front of the list.
  """
  @spec list_posts() :: [Post.t()]
  def list_posts() do
    Post.where_approved()
    |> Post.where_fresh()
    |> Post.order_by_sponsor_owner_asc()
    |> Repo.all()
  end

  @doc """
  Retrieves all job posts which are not approved.
  """
  @spec list_unapproved_posts() :: [Post.t()]
  def list_unapproved_posts() do
    Post.from()
    |> Post.where_unapproved()
    |> Repo.all()
  end

  @doc """
  Retrieves all job posts by an author with the provided id.
  """
  @spec list_posts_by_author_id(term()) :: [Post.t()]
  def list_posts_by_author_id(author_id) do
    author_id
    |> Post.where_author_id()
    |> Repo.all()
  end

  @doc """
  Retrieves a job post by its id.
  """
  @spec get_post!(term()) :: Post.t()
  def get_post!(id) do
    id
    |> Post.where_id()
    |> Repo.one!()
  end

  @doc """
  Creates a job post.

  A job post can be created by a sponsor-associated member if the sponsor hasn't
  yet reached the posts quota. If the member is not associated to a sponsor, the
  rule is applied to the member itself.
  """
  @spec create_post(Member.t(), create_post_params()) :: {:ok, Post.t()} | {:error, Error.t()}
  def create_post(%Member{} = member, attrs) do
    transact(fn ->
      with {:authz, true} <- {:authz, can_create_post?(member)},
           {:ok, post} <- do_insert_post(member, attrs),
           created_by = post.created_by,
           :ok <- update_post_history(:insert, created_by, post),
           :ok <- send_post_submission_notifications(created_by) do
        {:ok, post}
      else
        {:authz, false} ->
          {:error, Error.exception(:post_quota_reached)}

        {:error, %Changeset{} = cs} ->
          {:error, Error.exception({:changeset, cs})}
      end
    end)
  end

  defp do_insert_post(member, attrs) do
    result =
      member
      |> Ecto.build_assoc(:posts)
      |> Post.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, post} ->
        post =
          post
          |> Map.put(:sponsor_id, member.sponsor_id)
          |> Map.put(:updated_by, post.created_by)

        {:ok, post}

      error ->
        error
    end
  end

  @doc """
  Approves a job post.

  The job post can be approved only by a member who is an admin.
  """
  @spec approve_post(Member.t(), Post.t()) :: {:ok, Post.t()} | {:error, Error.t()}
  def approve_post(%Member{is_app_admin: true} = member, %Post{} = post) do
    transact(fn ->
      with {:ok, post} <- do_update_post(member, post, %{approved: true}),
           {:ok, _} <- send_post_approval_notification(post.created_by, post.title) do
        {:ok, post}
      else
        {:error, %Changeset{} = cs} ->
          {:error, Error.exception({:changeset, cs})}
      end
    end)
  end

  def approve_post(%Member{}, %Post{}) do
    {:error, Error.exception(:unauthorized)}
  end

  @doc """
  Updates a job post.

  The job post can be updated by its author, by a member associated to the same
  sponsor as the author, or an admin.
  """
  @spec update_post(Member.t(), Post.t(), update_post_params()) ::
          {:ok, Post.t()} | {:error, Changeset.t() | Error.t()}
  def update_post(%Member{} = member, %Post{} = post, %{} = attrs) do
    if owns_post?(member, post) do
      transact(fn ->
        with {:ok, post} <- do_update_post(member, post, attrs),
             :ok <- update_post_history(:update, post.updated_by, post) do
          {:ok, post}
        else
          {:error, %Changeset{} = cs} ->
            {:error, Error.exception({:changeset, cs})}
        end
      end)
    else
      {:error, Error.exception(:unauthorized)}
    end
  end

  defp do_update_post(%Member{id: updated_by}, %Post{} = post, %{} = attrs) do
    changeset = Post.changeset(post, attrs)

    with {:ok, post} <- Repo.update(changeset) do
      {:ok, Map.put(post, :updated_by, updated_by)}
    end
  end

  @doc """
  Deletes a job post.

  The job post can be deleted by its author, by a member associated to the same
  sponsor as the author, or an admin.
  """
  @spec delete_post(Member.t(), Post.t()) ::
          {:ok, Post.t()} | {:error, Changeset.t() | :unauthorized}
  def delete_post(%Member{} = member, %Post{} = post) do
    if owns_post?(member, post) do
      Repo.transaction(fn ->
        with {:ok, deleted_post} <- Repo.delete(post),
             deleted_by = member.id,
             :ok <- update_post_history(:delete, deleted_by, deleted_post) do
          deleted_post
        else
          {:error, %Changeset{} = cs} ->
            Repo.rollback(Error.exception({:changeset, cs}))
        end
      end)
    else
      {:error, Error.exception(:unauthorized)}
    end
  end

  @spec change_post(Post.t(), map()) :: Changeset.t()
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @spec sponsored_post?(Post.t()) :: boolean()
  def sponsored_post?(%Post{sponsor_id: nil}), do: false
  def sponsored_post?(%Post{}), do: true

  @doc """
  Returns whether a member owns a job post.

  A member owns a job post if the member is an admin, the creator of the post,
  or another member associated to the same sponsor is the author.
  """
  @spec owns_post?(Member.t(), Post.t()) :: boolean()
  def owns_post?(%Member{is_app_admin: true}, %Post{}), do: true

  # Both `created_by` and `id` are required so there's no need to check for them
  # being non-nil.
  def owns_post?(%Member{id: id}, %Post{created_by: id}), do: true

  def owns_post?(%Member{sponsor_id: id}, %Post{sponsor_id: id}) when not is_nil(id),
    do: true

  def owns_post?(%Member{}, %Post{}), do: false

  @doc """
  Returns wether a member or the sponsor it's related, if it's related to a
  sponsor at all, to has reached the posts quota.
  """
  @spec can_create_post?(Member.t()) :: boolean()
  def can_create_post?(%Member{} = member) do
    base_query =
      case member do
        %Member{id: id, sponsor_id: nil} ->
          Post.where_author_id(id)

        %Member{sponsor_id: id} ->
          Post.with_author()
          |> Member.where_sponsor_id(id)
      end

    base_query
    |> Post.where_inserted_in_current_year()
    |> Repo.count()
    |> then(negate(&reached_posts_quota?/1))
  end

  defp reached_posts_quota?(count) when count >= @max_posts_per_author, do: true

  defp reached_posts_quota?(_), do: false

  defp negate(f) when is_function(f, 1) do
    &(!f.(&1))
  end

  # This shouldn't be an application-level concern. History tracking is best
  # performed by the system that stores the data. Proper implementation involves
  # writing SQL triggers which can be hairy.
  defp update_post_history(action, member_id, post) do
    {:ok, _} =
      Repo.transaction(fn ->
        case action do
          :insert ->
            :ok = create_post_history_entry(member_id, post)

          :delete ->
            :ok = delete_post_history_entry(member_id, post.id)

          :update ->
            :ok = delete_post_history_entry(member_id, post.id)
            :ok = create_post_history_entry(member_id, post)
        end
      end)

    :ok
  end

  defp delete_post_history_entry(member_id, post_id) do
    history_entry_query =
      from(ph in PostHistoryEntry,
        where: fragment("?::tstzrange @> current_timestamp", ph.valid_range),
        where: [id: ^post_id],
        update: [
          set: [
            deleted_by: ^member_id,
            deleted_at: fragment("current_timestamp")
          ]
        ]
      )

    {1, _} = Repo.update_all(history_entry_query, [])

    :ok
  end

  defp create_post_history_entry(member_id, %Post{} = post) do
    attrs =
      post
      |> Map.from_struct()
      |> Map.put(:created_by, member_id)

    {:ok, _} =
      %PostHistoryEntry{}
      |> PostHistoryEntry.changeset(attrs)
      |> Repo.insert()

    :ok
  end

  defp send_post_submission_notifications(member_id) do
    params = [
      %{
        module: Erlef.Admins.Notifications,
        fun: :new_job_post_submission,
        args: []
      },
      %{
        module: Erlef.Members.Notifications,
        fun: :new_job_post_submission,
        args: [member_id]
      }
    ]

    [_, _] =
      params
      |> Enum.map(&Erlef.Outbox.Email.new/1)
      |> Oban.insert_all()

    :ok
  end

  defp send_post_approval_notification(member_id, post_title) do
    %{
      module: Erlef.Members.Notifications,
      fun: :job_post_approval,
      args: [member_id, post_title]
    }
    |> Erlef.Outbox.Email.new()
    |> Oban.insert()
  end

  def format_error({:changeset, cs}), do: inspect(cs)

  def format_error(:post_quota_reached), do: "The member has reached the post quota."

  def format_error(:unauthorized), do: "The member is unauthorized to perform this operation."

  # Works like `Ecto.Repo.transaction` but only with functions which return a
  # result tuple.
  #
  # Removes the need to destructure the error tuple, and rollback with it in
  # order to return a tuple result from the transaction.
  @dialyzer {:nowarn_function, transact: 2}
  defp transact(fun, opts \\ []) do
    Repo.transaction(
      fn repo ->
        {:arity, arity} = Function.info(fun, :arity)

        result =
          case arity do
            0 ->
              fun.()

            1 ->
              fun.(repo)

            other ->
              raise ArgumentError,
                    "A function with arity 0 or 1 expected but got one with arity #{other}."
          end

        case result do
          {:ok, result} ->
            result

          {:error, error} ->
            Repo.rollback(error)
        end
      end,
      opts
    )
  end
end
