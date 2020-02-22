defmodule Erlef.Test.Recaptcha do
  @moduledoc false

  use Plug.Router
  plug(:match)
  plug(:dispatch)

  def init(options), do: options

  def start(ref \\ __MODULE__) do
    Plug.Cowboy.http(__MODULE__, [], ref: ref, port: 9998)
  end

  def stop(ref \\ __MODULE__) do
    Plug.Cowboy.shutdown(ref)
  end

  post "recaptcha/api/siteverify" do
    {:ok, params, conn} = Plug.Conn.read_body(conn)

    res =
      case params do
        <<"response=valid"::binary, _rest::binary>> ->
          %{"success" => true}

        _ ->
          %{"success" => false}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(res))
  end
end
