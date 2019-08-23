defmodule Erlef.GrantProposal do
  @string_key_map %{
    "first_name" => :first_name,
    "last_name" => :last_name,
    "nick_name" => :nick_name,
    "email_address" => :email_address,
    "phone_number" => :phone_number,
    "alt_phone_number" => :alt_phone_number,
    "org_name" => :org_name,
    "org_email" => :org_email,
    "org_phone_number" => :org_phone_number,
    "city" => :city,
    "province" => :province,
    "country" => :country,
    "postal_code" => :postal_code,
    "twitter" => :twitter,
    "linkedin" => :linkedin,
    "website" => :website,
    "bio" => :bio,
    "code_of_conduct_link" => :code_of_conduct_link,
    "files" => :files,
    "purpose" => :purpose,
    "grant_type" => :grant_type,
    "grant_amount" => :grant_amount,
    "payment_method" => :payment_method,
    "beneficiaries" => :beneficiaries,
    "report" => :report
  }

  defstruct Map.values(@string_key_map)

  def from_map(params) do
    kept = Map.take(params, Map.keys(@string_key_map))

    Enum.reduce(kept, %__MODULE__{}, fn {k, v}, acc ->
      %{acc | Map.get(@string_key_map, k) => v}
    end)
  end
end
