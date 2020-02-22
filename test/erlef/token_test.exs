defmodule Erlef.TokenTest do
  use ExUnit.Case, async: true

  test "generate_secret/0" do
    assert <<_secret::binary-size(24)>> = Erlef.Token.generate_secret()
  end

  test "encrypt/2" do
    key = Erlef.Token.generate_secret()
    assert {:ok, <<_secret::binary-size(48)>>} = Erlef.Token.encrypt(%{}, key)
  end

  test "decrypt/2" do
    key = Erlef.Token.generate_secret()
    {:ok, payload} = Erlef.Token.encrypt(%{}, key)
    {:ok, %{}} = Erlef.Token.decrypt(payload, key)
  end
end
