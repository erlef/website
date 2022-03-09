defmodule ErlefWeb.PageViewTest do
  use ErlefWeb.ConnCase, async: true

  alias ErlefWeb.PageView

  test "community_card_wall/1" do
    items = [%{icon: nil, logo: "logo", name: "name", about: "about", link: "link"}]
    assert %Phoenix.LiveView.Rendered{} = PageView.community_card_wall(items)

    items = [%{icon: "icon", logo: nil, name: "name", about: "about", link: "link"}]
    assert %Phoenix.LiveView.Rendered{} = PageView.community_card_wall(items)

    items = [%{icon: nil, logo: nil, name: "name", about: "about", link: "link"}]
    assert %Phoenix.LiveView.Rendered{} = PageView.community_card_wall(items)
  end

  test "fellows_card_wall/1" do
    fellows = [%{name: "name", avatar: "avatar", about: "about"}]
    assert %Phoenix.LiveView.Rendered{} = PageView.fellows_card_wall(fellows)
  end
end
