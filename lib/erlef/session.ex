defmodule Erlef.Session do
  @moduledoc """
  Erlef.Session - Session handler and session serializer/deserializer
  """

  @enforce_keys [
    :account_id,
    :member_id,
    :access_token,
    :refresh_token,
    :username,
    :expires_at
  ]
  defstruct [
    :account_id,
    :member,
    :member_id,
    :access_token,
    :refresh_token,
    :username,
    :expires_at
  ]

  @type auth_data() :: map()

  @type t() :: %__MODULE__{
          account_id: integer(),
          member_id: integer(),
          access_token: String.t(),
          refresh_token: String.t(),
          username: String.t(),
          expires_at: String.t()
        }

  @data_map %{
    "account_id" => :account_id,
    "member_id" => :member_id,
    "access_token" => :access_token,
    "refresh_token" => :refresh_token,
    "username" => :username,
    "expires_at" => :expires_at
  }

  @spec new(map()) :: t()
  def new(%{"expires_in" => expires_in} = data) do
    %{
      "Permissions" => [%{"AccountId" => aid} | _],
      "access_token" => access_token,
      "refresh_token" => refresh_token
    } = data

    {:ok, %{"Id" => uid, "DisplayName" => username}} = Erlef.WildApricot.me(access_token, aid)
    {:ok, member} = Erlef.Accounts.get_member(uid)

    %__MODULE__{
      account_id: aid,
      member: member,
      member_id: uid,
      access_token: access_token,
      refresh_token: refresh_token,
      username: username,
      expires_at: expires_at(expires_in)
    }
  end

  @spec normalize(map()) :: t() | nil
  def normalize(nil), do: nil

  def normalize(data) do
    normal =
      Enum.reduce(data, %{}, fn {k, v}, acc ->
        case @data_map[k] do
          nil ->
            acc

          key ->
            Map.put(acc, key, v)
        end
      end)

    {:ok, member} = Erlef.Accounts.get_member(normal.member_id)
    struct(__MODULE__, Map.put(normal, :member, member))
  end

  def encode(%{"member_session" => session = %__MODULE__{}} = data) do
    map =
      session
      |> Map.from_struct()
      |> Map.delete(:member)

    updated = Map.put(data, "member_session", map)
    Jason.encode(updated)
  end

  def encode(val), do: Jason.encode(val)

  def decode(val), do: Jason.decode(val)

  @spec expires_at(integer()) :: String.t()
  def expires_at(expires_in) do
    DateTime.to_string(Timex.shift(DateTime.utc_now(), seconds: expires_in))
  end

  @spec expired?(t()) :: boolean()
  def expired?(%{expires_at: expires_at}) do
    {:ok, dt, _} = DateTime.from_iso8601(expires_at)

    case Timex.diff(dt, DateTime.utc_now(), :seconds) do
      n when n <= 0 -> true
      _ -> false
    end
  end

  @spec login_uri() :: no_return()
  def login_uri(), do: Erlef.WildApricot.gen_login_uri()

  @spec login(any()) :: {:ok, t()} | {:error, term()}
  def login(code) do
    case Erlef.WildApricot.login(code) do
      {:ok, data} ->
        {:ok, new(data)}

      {:error, %{"error_description" => "No account can be accessed with specified credentials."}} ->
        {:error, "Invalid login"}

      err ->
        err
    end
  end

  @spec logout(t()) :: term()
  def logout(%{access_token: access_token, refresh_token: refresh_token}) do
    Erlef.WildApricot.user_logout(access_token, refresh_token)
  end

  @spec refresh(t()) :: {:ok, t()} | {:error, term()}
  def refresh(%{refresh_token: refresh_token}) do
    case Erlef.WildApricot.user_refresh(refresh_token) do
      {:ok, data} ->
        {:ok, new(data)}

      err ->
        err
    end
  end

  @spec should_refresh?(t()) :: boolean()
  def should_refresh?(%{expires_at: expires_at}) do
    {:ok, dt, _} = DateTime.from_iso8601(expires_at)

    case Timex.diff(dt, DateTime.utc_now(), :minutes) do
      n when n < 15 -> true
      _ -> false
    end
  end
end
