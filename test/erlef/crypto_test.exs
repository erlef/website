defmodule Erlef.CryptoTest do
  use ExUnit.Case, async: true

  alias Erlef.Crypto

  test "compare/2" do
    assert Crypto.compare("this", "this")
    refute Crypto.compare("this", "that")
  end

  test "hmac_encode/2" do
    hash = Crypto.hmac_encode("key", "data")
    assert is_binary(hash)
    assert hash == Crypto.hmac_encode("key", "data")
    refute hash == Crypto.hmac_encode("kee", "data")
  end
end
