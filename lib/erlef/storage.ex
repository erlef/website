defmodule Erlef.Storage do
  @moduledoc false
  alias ExAws.S3

  @spec upload_event_org_image(String.t(), binary(), Keyword.t()) ::
          {:ok, String.t()} | {:error, term()}
  def upload_event_org_image(filename, binary, opts \\ []) do
    new_opts = [{:content_type, file_type(binary)}, {:acl, :public_read}] ++ opts
    operation = S3.put_object("event-org-images", filename, binary, new_opts)

    case ExAws.request(operation) do
      {:ok, _} ->
        {:ok, image_url(filename, "event-org-images")}

      err ->
        err
    end
  end

  @spec upload_sponsor_image(String.t(), binary(), Keyword.t()) ::
          {:ok, String.t()} | {:error, term()}
  def upload_sponsor_image(filename, binary, opts \\ []) do
    new_opts = [{:content_type, file_type(binary)}, {:acl, :public_read}] ++ opts
    operation = S3.put_object("sponsors", filename, binary, new_opts)

    case ExAws.request(operation) do
      {:ok, _} ->
        {:ok, image_url(filename, "sponsors")}

      err ->
        err
    end
  end

  @spec upload_avatar_image(String.t(), binary(), Keyword.t()) ::
          {:ok, String.t()} | {:error, term()}
  def upload_avatar_image(filename, binary, opts \\ []) do
    new_opts = [{:content_type, file_type(binary)}, {:acl, :public_read}] ++ opts
    operation = S3.put_object("avatar-images", filename, binary, new_opts)

    case ExAws.request(operation) do
      {:ok, _} ->
        {:ok, image_url(filename, "avatar-images")}

      err ->
        err
    end
  end

  defp image_url(filename, bucket) do
    case Erlef.in_env?([:dev, :test]) do
      true ->
        "http://127.0.0.1:9998/#{bucket}/#{filename}"

      false ->
        "https://#{bucket}.ewr1.vultrobjects.com/#{filename}"
    end
  end

  defp file_type(<<0xFF, 0xD8, _::binary>>), do: "image/jpeg"

  defp file_type(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>),
    do: "image/png"

  defp file_type(_not_supported), do: {:error, :unsupported}
end
