defmodule ErlefWeb.PlugAttack do
  use PlugAttack
  import Plug.Conn

  rule "allow local", %{remote_ip: {127, 0, 0, 1}} = conn do
    allow(conn)
  end

  rule "throttle by ip", %{path_info: ["slack-invite" | _rest]} = conn do
    throttle(conn.remote_ip,
      period: 60_000,
      limit: 5,
      storage: {PlugAttack.Storage.Ets, MyApp.PlugAttack.Storage}
    )
  end

  def block_action(conn, _data, _opts) do
    conn
    |> send_resp(429, "Whoa slow down there partner!”")
    |> halt
  end
end
