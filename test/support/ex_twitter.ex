defmodule Erlef.ExTwitterTest do
  @moduledoc "Stub for Twitter test"

  def user_timeline([screen_name: _, count: 3]) do
    [
      %{
        id_str: "1234310127987175426",
        user: %{
          name: "Hunter S. Thompson",
          screen_name: "GonzoVice",
          profile_image_url_https: "https://pbs.twimg.com/profile_images/1190795475773001728/wGyPLpYA_normal.jpg",
        },
        created_at: "Mon Mar 02 02:50:41 +0000 2020",
        text: "In a democracy, people usually get the kind of government they deserve."
      },
      %{
        id_str: "1234310127987175426",
        user: %{
          name: "Hunter S. Thompson",
          screen_name: "GonzoVice",
          profile_image_url_https: "https://pbs.twimg.com/profile_images/1190795475773001728/wGyPLpYA_normal.jpg",
        },
        created_at: "Mon Mar 02 02:50:41 +0000 2020",
        text: "In a democracy, people usually get the kind of government they deserve."
      },
      %{
        id_str: "1234310127987175426",
        user: %{
          name: "Hunter S. Thompson",
          screen_name: "GonzoVice",
          profile_image_url_https: "https://pbs.twimg.com/profile_images/1190795475773001728/wGyPLpYA_normal.jpg",
        },
        created_at: "Mon Mar 02 02:50:41 +0000 2020",
        text: "In a democracy, people usually get the kind of government they deserve."
      }
    ]
  end
end
