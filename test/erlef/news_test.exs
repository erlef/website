defmodule Erlef.NewsTest do
  use Erlef.DataCase

  alias Erlef.News
  alias Erlef.News.NewsTip
  alias Erlef.News.NewsTip.SupportingDocument

  describe "news_tips" do
    @valid_attrs %{
      type: :announcement,
      status: :queued,
      who: "some who",
      what: "some what",
      at_where: "some where",
      at_when: "some at_when",
      why: "some why",
      how: "some how",
      supporting_documents: [%{url: "http://foo.bar", mime: "image/png"}],
      additional_info: "some additional_info"
    }

    @update_attrs %{
      status: :in_progress,
      note: "Requires further research",
      priority: 42
    }

    @invalid_attrs %{
      status: :eh
    }

    def news_tip_fixture(attrs \\ %{}) do
      {:ok, news_tip} =
        attrs
        |> Enum.into(@valid_attrs)
        |> News.create_news_tip()

      news_tip
    end

    setup do
      member = insert_member!("basic_member")
      admin = insert_member!("admin")
      %{member: member, admin: admin}
    end

    test "get_news_tip!/1 returns the news_tip with given id", %{member: member} do
      news_tip = news_tip_fixture(created_by_id: member.id)
      assert News.get_news_tip!(news_tip.id) == news_tip
    end

    test "create_news_tip/1 with valid data creates a news_tip", %{member: member} do
      attrs = Map.put(@valid_attrs, :created_by_id, member.id)
      assert {:ok, %NewsTip{} = news_tip} = News.create_news_tip(attrs)

      assert news_tip.additional_info == "some additional_info"
      assert news_tip.how == "some how"
      assert news_tip.notes == []
      assert news_tip.priority == 0
      assert news_tip.status == :queued

      assert [%SupportingDocument{mime: "image/png", url: "http://foo.bar"}] =
               news_tip.supporting_documents

      assert news_tip.type == :announcement
      assert news_tip.what == "some what"
      assert news_tip.at_when == "some at_when"
      assert news_tip.who == "some who"
      assert news_tip.why == "some why"
    end

    test "create_news_tip/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = News.create_news_tip(@invalid_attrs)
    end

    test "update_news_tip/2 with valid data updates the news_tip", %{member: member, admin: admin} do
      news_tip = news_tip_fixture(created_by_id: member.id)

      attrs =
        @update_attrs
        |> Map.put(:updated_by_id, admin.id)
        |> Map.put(:assigned_to_id, admin.id)

      assert {:ok, %NewsTip{} = news_tip} = News.update_news_tip(news_tip, attrs)

      assert news_tip.status == :in_progress
      assert [note] = news_tip.notes
      assert note.text == "Requires further research"
      assert note.created_by_id == admin.id
      assert news_tip.priority == 42
      assert news_tip.updated_by_id == admin.id
      assert news_tip.assigned_to_id == admin.id
      assert [news_tip_log] = news_tip.logs
      assert news_tip_log.changed_by_id == admin.id

      exp = %{
        assigned_to_id: admin.id,
        note: "Requires further research",
        priority: 42,
        status: :in_progress,
        updated_by_id: admin.id
      }

      assert news_tip_log.changes == exp
    end

    test "update_news_tip/2 with invalid data returns error changeset", %{member: member} do
      news_tip = news_tip_fixture(created_by_id: member.id, updated_by_id: member.id)

      attrs = Map.put(@invalid_attrs, :updated_by_id, member.id)
      assert {:error, %Ecto.Changeset{}} = News.update_news_tip(news_tip, attrs)

      assert news_tip == News.get_news_tip!(news_tip.id)
    end
  end
end
