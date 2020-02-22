defmodule Erlef.Token do
  @moduledoc """
  Erlef.Token serializer and deserializer
  """
  @aad "AES256GCM"

  def generate_secret do
    :crypto.strong_rand_bytes(16)
    |> :base64.encode()
  end

  def encrypt(val, key) do
    {:ok, val} = Jason.encode(val)
    iv = :crypto.strong_rand_bytes(16)

    {ciphertext, tag} =
      :crypto.block_encrypt(:aes_gcm, decode_key(key), iv, {@aad, to_string(val), 16})

    msg = Base.encode64(iv <> tag <> ciphertext)
    {:ok, msg}
  end

  @doc """
  decrypts the given string of text with the given secret key
  """
  def decrypt(ciphertext, key) do
    {:ok, ciphertext} = Base.decode64(ciphertext)
    <<iv::binary-16, tag::binary-16, ciphertext::binary>> = ciphertext
    msg = :crypto.block_decrypt(:aes_gcm, decode_key(key), iv, {@aad, ciphertext, tag})
    Jason.decode(msg)
  end

  def decode_key(key) do
    :base64.decode(key)
  end
end
