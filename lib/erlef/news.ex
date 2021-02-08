defmodule Erlef.News do
  @moduledoc """
  The News context.
  """

  alias Erlef.News.NewsTip
  alias Erlef.Repo

  def list_news_tips_by_member(member), do: Repo.all(NewsTip.by_member(member))

  def get_news_tip!(id), do: Repo.get!(NewsTip, id)

  def create_news_tip(attrs \\ %{}) do
    %NewsTip{}
    |> NewsTip.changeset(maybe_upload_documents(attrs))
    |> Repo.insert()
  end

  def update_news_tip(%NewsTip{} = news_tip, attrs) do
    news_tip
    |> NewsTip.update_changeset(attrs)
    |> Repo.update()
  end

  defp maybe_upload_documents(%{"supporting_documents" => nil} = params), do: params

  defp maybe_upload_documents(%{"supporting_documents" => uploads} = params) do
    files =
      Enum.map(uploads, fn u ->
        content = File.read!(u.path)
        filename = unique_image_filename(u.content_type)
        {:ok, url} = Erlef.Storage.upload_news_document(filename, content)
        %{url: url, mime: u.content_type}
      end)

    Map.put(params, "supporting_documents", files)
  end

  defp maybe_upload_documents(params), do: params

  defp unique_image_filename(<<"image/", ext::binary>>) do
    Ecto.UUID.generate() <> "." <> ext
  end
end
