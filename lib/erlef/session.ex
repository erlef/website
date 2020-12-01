defmodule Erlef.Session do
  @moduledoc """
  Erlef.Session - Session handler and session serializer/deserializer
  """

  alias Erlef.Accounts
  alias Erlef.Accounts.Member

  @enforce_keys [
    :account_id,
    :member_id,
    :access_token,
    :refresh_token,
    :username,
    :expires_at,
    :erlef_app_id
  ]
  defstruct [
    :account_id,
    :member,
    :member_id,
    :access_token,
    :refresh_token,
    :username,
    :expires_at,
    :erlef_app_id
  ]

  @type auth_data() :: map()

  @type t() :: %__MODULE__{
          account_id: String.t(),
          member_id: String.t(),
          member: Erlef.Accounts.Member.t(),
          access_token: String.t(),
          refresh_token: String.t(),
          username: String.t(),
          expires_at: String.t(),
          erlef_app_id: Ecto.UUID.t()
        }

  @data_map %{
    "account_id" => :account_id,
    "member_id" => :member_id,
    "access_token" => :access_token,
    "refresh_token" => :refresh_token,
    "username" => :username,
    "expires_at" => :expires_at,
    "erlef_app_id" => :erlef_app_id
  }

  @spec new(map()) :: t()
  def new(%{"expires_in" => expires_in} = data) do
    %{
      "Permissions" => [%{"AccountId" => aid} | _],
      "access_token" => token,
      "refresh_token" => refresh_token
    } = data

    {:ok, %{"Id" => uid, "DisplayName" => username}} = Erlef.WildApricot.me(aid, token)

    {:ok, member} = Erlef.Accounts.get_member(uid)

    member = maybe_put_uuid(member)

    %__MODULE__{
      account_id: aid,
      member: member,
      member_id: uid,
      erlef_app_id: member.id,
      access_token: token,
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

    member = Map.from_struct(session.member)

    updated = Map.put(data, "member_session", Map.put(map, :member, member))
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

  @spec login(any()) :: {:ok, t()} | term()
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
    Erlef.WildApricot.logout(access_token, refresh_token)
  end

  @spec refresh(t()) :: {:ok, t()} | term()
  def refresh(%{refresh_token: refresh_token}) do
    case Erlef.WildApricot.refresh(refresh_token) do
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

  defp maybe_put_uuid(%Member{id: nil} = member) do
    uuid = Ecto.UUID.generate()
    Accounts.update_member(member, %{id: uuid})
    %{member | id: uuid}
  end

  defp maybe_put_uuid(member), do: member
end
