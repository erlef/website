defmodule Erlef.Members.EmailRequestNotification do
  @moduledoc false

  import Swoosh.Email

  def email_alias_created(member) do
    new()
    |> to({member.name, member.email})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("Your erlef.org email alias has been created!")
    |> text_body(alias_body(member))
  end

  def email_box_created(member, password) do
    new()
    |> to({member.name, member.email})
    |> from({"Erlef Notifications", "notifications@erlef.org"})
    |> subject("Your erlef.org email account has been created!")
    |> text_body(email_box_body(member, password))
  end

  defp alias_body(member) do
    """
    Hello #{member.first_name},

    We are glad to inform you that the mail alias you requested has been created.

    It may take up to 15 minutes for the alias to become active. Once the alias is active you will
    begin receiving emails sent to your new alias at this address.

    If you have any problems, please reach out to infra.requests@erlef.org
    """
  end

  defp email_box_body(member, password) do
    """
    Hello #{member.first_name},

    We are glad to inform you that the erlef.org mail account you requested has been created.

    You may login at https://fastmail.com/login using your new email address and the following credentials :

    username : #{member.erlef_email_address} 
    password : #{password}

    Once logged in we strongly advise you change this password immediately and enable two-factor authentication. 
    See https://www.fastmail.com/help/guides/personal.html for information on getting started with
    your new email account.

    If you have any problems logging in, please reach out to infra.requests@erlef.org
    """
  end
end
