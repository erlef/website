defmodule Erlef.Test.S3 do
  @moduledoc false

  import Plug.Conn

  use Plug.Router
  plug Plug.Logger, log: :debug
  plug(:match)
  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def init(options), do: options

  def add_file(filename, file) do
    true = :ets.insert(__MODULE__, {filename, file})
  end

  def start_link(_opts) do
    start()
  end

  def start(ref \\ __MODULE__) do
    _tid = :ets.new(__MODULE__, [:named_table, :public, {:write_concurrency, true}])

    for path <- Path.wildcard(Path.absname("test/support/data/ics/*.ics")) do
      add_file(Path.basename(path), File.read!(path))
    end

    Plug.Cowboy.http(__MODULE__, [], ref: ref, port: 9998)
  end

  def stop(ref \\ __MODULE__) do
    Plug.Cowboy.shutdown(ref)
  end

  put "/:bucket/:filename" do
    {:ok, file, conn} = Plug.Conn.read_body(conn)
    true = :ets.insert(__MODULE__, {filename, file})
    Plug.Conn.send_resp(conn, 201, "")
  end

  get "/calendars/:filename" do
    case :ets.lookup(__MODULE__, filename) do
      [{_path, file}] ->
        conn
        |> put_resp_header("Access-Control-Allow-Origin", "*")
        |> put_resp_content_type("text/plain")
        |> send_resp(200, file)

      _ ->
        send_resp(conn, 404, "oops")
    end
  end

  get "/:bucket/:filename" do
    case :ets.lookup(__MODULE__, filename) do
      [{_path, file}] ->
        send_resp(conn, 200, file)

      _ ->
        send_resp(conn, 404, "oops")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
