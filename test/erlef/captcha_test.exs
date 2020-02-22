defmodule Erlef.CaptchaTest do
  use ExUnit.Case, async: true

  # See test/support/models/recaptcha.ex for service details

  describe "verify_recaptcha/1" do
    test "when token is valid" do
      assert {:ok, :verified} = Erlef.Captcha.verify_recaptcha("valid")
    end

    test "when token is invalid" do
      assert {:error, "Invalid recaptcha response"} = Erlef.Captcha.verify_recaptcha("invalid")
    end
  end
end
