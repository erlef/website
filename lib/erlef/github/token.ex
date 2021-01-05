defmodule Erlef.Github.Token do
  @moduledoc false

  use Joken.Config

  def gen_app_token(app_id, pem) do
    p = %{
      alg: "RS256",
      jwk: JOSE.JWK.from_pem(pem),
      jws: %JOSE.JWS{
        alg: {:jose_jws_alg_rsa_pkcs1_v1_5, :RS256},
        b64: :undefined,
        fields: %{"typ" => "JWT"}
      }
    }

    Joken.Signer
    |> struct(p)
    |> gen(%{"iss" => app_id})
  end

  def gen(signer, p \\ %{}) do
    generate_and_sign(p, signer)
  end

  def token_config do
    default_claims()
    |> add_claim("iat", fn -> Joken.current_time() end, &is_integer(&1))
    |> add_claim("exp", fn -> Joken.current_time() + 600 end, &is_integer(&1))
  end
end
