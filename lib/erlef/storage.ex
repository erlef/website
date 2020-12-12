defmodule Erlef.Storage do
  @moduledoc false
  alias ExAws.S3

  @spec upload_event_org_image(String.t(), binary(), Keyword.t()) ::
          {:ok, String.t()} | {:error, term()}
  def upload_event_org_image(filename, binary, opts \\ []) do
    new_opts = [{:content_type, MIME.from_path(filename)}, {:acl, :public_read}] ++ opts
    operation = S3.put_object("event-org-images", filename, binary, new_opts)

    case ExAws.request(operation) do
      {:ok, _} ->
        {:ok, image_url(filename)}

      err ->
        err
    end
  end

  defp image_url(filename) do
    case Erlef.in_env?([:dev, :test]) do
      true ->
        "http://127.0.0.1:9998/event-org-images/#{filename}"

      false ->
        "https://event-org-images.ewr1.vultrobjects.com/#{filename}"
    end
  end
end
