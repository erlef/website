defmodule Erlef.Session do
  @moduledoc """
  Erlef.Session - Session handler and session serializer/deserializer
  """

  @enforce_keys [:account_id, :access_token, :refresh_token, :username, :expires_at, :is_admin]
  defstruct [:account_id, :access_token, :refresh_token, :username, :expires_at, :is_admin]

  @type auth_data() :: map()

  @type t() :: %__MODULE__{
          account_id: integer(),
          access_token: String.t(),
          refresh_token: String.t(),
          username: String.t(),
          expires_at: String.t(),
          is_admin: boolean()
        }

  @data_map %{
    "account_id" => :account_id,
    "access_token" => :access_token,
    "refresh_token" => :refresh_token,
    "username" => :username,
    "expires_at" => :expires_at,
    "is_admin" => :is_admin
  }

  @spec new(map()) :: t()
  def new(%{"expires_in" => expires_in} = data) do
    %{
      "Permissions" => [%{"AccountId" => aid} | _],
      "access_token" => access_token,
      "refresh_token" => refresh_token
    } = data

    {:ok, %{"Id" => uid, "DisplayName" => username}} = Erlef.WildApricot.me(access_token, aid)

    case is_admin(aid, uid) do
      truth when is_boolean(truth) ->
        %__MODULE__{
          account_id: aid,
          access_token: access_token,
          refresh_token: refresh_token,
          username: username,
          expires_at: expires_at(expires_in),
          is_admin: truth
        }

      err ->
        err
    end
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

    struct(__MODULE__, normal)
  end

  def encode(%{"member_session" => session = %__MODULE__{}} = data) do
    map = Map.from_struct(session)
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

  # TODO: Speed this up by caching the admin token in Erlef.Config
  @spec is_admin(integer(), integer()) :: boolean()

  if Erlef.is_env?(:dev) do
    def is_admin(_aid, _id) do
      true
    end

    def is_admin(_aid, _id) do
      false
    end
  end

  def is_admin(aid, uid) do
    with {:ok, %{"access_token" => api_token}} <- Erlef.WildApricot.get_api_token() do
      Erlef.WildApricot.is_admin(api_token, aid, uid)
    end
  end

  @spec login(String.t(), String.t()) :: {:ok, t()} | {:error, term()}

  #   if Erlef.is_env?(:dev) do
  #     @faux_dev_accounts ["member@erlef.test", "admin@erlef.test"]

  #     def login(u, _password) when u in @faux_dev_accounts do
  #       case u do
  #         "member@erlef.test" ->
  #           {:ok,
  #            %__MODULE__{
  #              access_token: "member_token",
  #              account_id: 12_345,
  #              expires_at: DateTime.to_string(Timex.shift(DateTime.utc_now(), minutes: 30)),
  #              is_admin: false,
  #              refresh_token: "rt_member_token",
  #              username: "member@erlef.test"
  #            }}

  #         "admin@erlef.test" ->
  #           {:ok,
  #            %__MODULE__{
  #              access_token: "admin_token",
  #              account_id: 54_321,
  #              expires_at: DateTime.to_string(Timex.shift(DateTime.utc_now(), minutes: 30)),
  #              is_admin: true,
  #              refresh_token: "rt_admin_token",
  #              username: "admin@erlef.test"
  #            }}
  #       end
  #     end
  #   end

  def login_uri(), do: Erlef.WildApricot.gen_login_uri()

  def login(code, state) do
    case Erlef.WildApricot.login(code, state) do
      {:ok, data} ->
        {:ok, new(data)}

      {:error, %{"error_description" => "No account can be accessed with specified credentials."}} ->
        {:error, "Invalid login"}

      err ->
        err
    end
  end

  @spec logout(t()) :: term()

  #   if Erlef.is_env?(:dev) do
  #     @faux_dev_access_tokens ["admin_token", "member_token"]
  #     def logout(%{access_token: t}) when t in @faux_dev_access_tokens do
  #       :ok
  #     end
  #   end

  def logout(%{access_token: access_token, refresh_token: refresh_token}) do
    Erlef.WildApricot.user_logout(access_token, refresh_token)
  end

  @spec refresh(t()) :: {:ok, t()} | {:error, term()}

  # if Erlef.is_env?(:dev) do
  #   def refresh(%{username: u} = session) when u in @faux_dev_accounts do
  #     {:ok,
  #      %{session | expires_at: DateTime.to_string(Timex.shift(DateTime.utc_now(), minutes: 30))}}
  #   end
  # end

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
