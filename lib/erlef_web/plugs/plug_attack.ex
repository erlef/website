defmodule ErlefWeb.PlugAttack do
  use PlugAttack
  import Plug.Conn

  if Erlef.is_env?(:dev) do
    rule "allow local", %{remote_ip: {127, 0, 0, 1}} = conn do
      allow(conn)
    end
  end

  rule "throttle by ip", %{path_info: ["slack-invite" | _rest]} = conn do
    throttle(conn.remote_ip,
      period: 60_000,
      limit: 5,
      storage: {PlugAttack.Storage.Ets, MyApp.PlugAttack.Storage}
    )
  end

  rule "throttle by ip", conn do
    allow conn
  end

  def block_action(conn, _data, _opts) do
    conn
    |> send_resp(429, "Whoa slow down there partner!”")
    |> halt
  end
end
