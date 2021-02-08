defmodule ErlefWeb.NewsTipController do
  use ErlefWeb, :controller

  alias Erlef.News
  alias Erlef.News.NewsTip

  def index(conn, _params) do
    news_tips = News.list_news_tips_by_member(conn.assigns.current_user)
    render(conn, "index.html", news_tips: news_tips)
  end

  def new(conn, _params) do
    changeset = NewsTip.changeset(%NewsTip{}, %{})
    types = Ecto.Enum.values(NewsTip, :type)
    render(conn, "new.html", types: types, changeset: changeset)
  end

  def create(conn, %{"news_tip" => params}) do
    case News.create_news_tip(normalize_news_tip_params(conn, params)) do
      {:ok, news_tip} ->
        conn
        |> put_flash(:info, "News tip created successfully.")
        |> redirect(to: Routes.news_tip_path(conn, :show, news_tip))

      {:error, %Ecto.Changeset{} = changeset} ->
        types = Ecto.Enum.values(NewsTip, :type)
        render(conn, "new.html", types: types, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    news_tip = News.get_news_tip!(id)
    render(conn, "show.html", news_tip: news_tip)
  end

  def normalize_news_tip_params(conn, params) do
    case Map.get(params, "supporting_documents") do
      nil ->
        Map.put(params, "created_by_id", conn.assigns.current_user.id)

      docs ->
        params
        |> Map.delete("supporting_documents")
        |> Map.put("status", "queued")
        |> Map.put("supporting_documents", Enum.map(docs, &Map.from_struct/1))
        |> Map.put("created_by_id", conn.assigns.current_user.id)
    end
  end
end
