defmodule Erlef.Twitter do
  @moduledoc """
  Wrapper around the ExTwitter library
  """

  defmodule Tweet do
    @moduledoc "Struct for tweets"

    @type t :: %__MODULE__{
            id: String.t(),
            name: String.t(),
            screen_name: String.t(),
            avatar: String.t(),
            posted_date: String.t(),
            text: String.t()
          }

    defstruct [:id, :name, :screen_name, :avatar, :posted_date, :text]
  end

  @screen_name "TheErlef"

  @doc """
  Returns the 3 most recent tweets for the EEF twitter account
  """
  @spec latest_tweets(client :: module()) :: [Tweet.t()]
  def latest_tweets(client \\ nil) do
    client = client || Application.get_env(:erlef, :twitter_client, ExTwitter)

    [
      screen_name: @screen_name,
      count: 3
    ]
    |> client.user_timeline()
    |> Enum.map(&format_tweet/1)
  end

  if Erlef.is_env?(:dev) do
    def user_timeline(_) do
      tweet = %{
        id_str: "1326232249054818305",
        user: %{
          name: "Erlang Ecosystem Foundation",
          screen_name: "TheErlef",
          profile_image_url_https:
            "https://pbs.twimg.com/profile_images/1099510098701910017/RSwfpAGg_normal.png"
        },
        text: "It's adventure time! https://t.co/5FTnyXb8AE",
        created_at: "Tue Nov 10 18:36:23 +0000 2020"
      }

      [tweet, tweet, tweet]
    end
  end

  defp format_tweet(tweet) do
    %Tweet{
      id: tweet.id_str,
      name: tweet.user.name,
      screen_name: tweet.user.screen_name,
      avatar: tweet.user.profile_image_url_https,
      posted_date: format_date(tweet.created_at),
      text: tweet.text
    }
  end

  defp format_date(
         <<_::binary-size(4), month::binary-size(3), " ", day::binary-size(2), _::binary-size(16),
           year::binary>>
       ) do
    "#{month} #{day}, #{year}"
  end

  defp format_date(date_string), do: date_string
end
