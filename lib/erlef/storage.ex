defmodule Erlef.Storage do
  @moduledoc false
  alias ExAws.S3

  @spec upload_event_org_image(String.t(), binary(), Keyword.t()) ::
          {:ok, String.t()} | {:error, term()}
  def upload_event_org_image(filename, binary, opts \\ []) do
    new_opts = [{:content_type, MIME.from_path(filename)}] ++ opts
    operation = S3.put_object("event-org-images", filename, binary, new_opts)

    case ExAws.request(operation) do
      {:ok, _} ->
        {:ok, "https://event-org-images.ewr1.vultrobjects.com/#{filename}"}

      err ->
        err
    end
  end
end
