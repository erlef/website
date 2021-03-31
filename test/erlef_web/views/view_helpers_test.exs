defmodule ErlefWeb.ViewHelpersTest do
  use ExUnit.Case
  import Erlef.Factory

  alias ErlefWeb.ViewHelpers, as: Helper

  describe "long_date/1" do
    test "returns a long formated date from a %DateTime{}" do
      {_, datetime, _} = DateTime.from_iso8601("1971-11-25T23:50:07Z")

      assert "November 25, 1971" = Helper.long_date(datetime)
    end

    test "returns the value when arg is NOT a %DateTime{}" do
      assert "Publication date‎: ‎November 25, 1971" =
               Helper.long_date("Publication date‎: ‎November 25, 1971")
    end

    test "returns empty string from a nil" do
      assert "" = Helper.long_date(nil)
    end
  end

  describe "long_date_time/1" do
    test "returns a long formated date from a %DateTime{}" do
      {_, datetime, _} = DateTime.from_iso8601("1971-11-25T23:50:07Z")

      assert "1971-11-25 23:50:07" == Helper.long_date_time(datetime)
    end

    test "returns empty string from a nil" do
      assert "" = Helper.long_date_time(nil)
    end

    test "returns the input when not nil or date time" do
      assert :eh = Helper.long_date_time(:eh)
    end
  end

  describe "event_dates/2" do
    test "formats start and end to english dates" do
      date = ~D[2020-12-06]
      assert "December 06 - December 06, 2020" == Helper.event_dates(date, date)
    end

    test "when end date is nil" do
      date = ~D[2020-12-06]
      assert "December 06, 2020" == Helper.event_dates(date, nil)
    end

    test "when start_date and end_date are strings" do
      start_date = "December 06, 2020"
      end_date = "December 07, 2020"
      assert "#{start_date} - #{end_date}" == Helper.event_dates(start_date, end_date)
    end
  end

  describe "active_and_founding_sponsors/1" do
    test "reduces to active founding sponsors" do
      sponsors = [
        build(:sponsor, %{active: true}),
        build(:sponsor, %{active: false}),
        build(:sponsor, %{active: true, is_founding_sponsor: true})
      ]

      count =
        sponsors
        |> Helper.active_and_founding_sponsors()
        |> Enum.count()

      assert count == 1
    end

    test "returns an empty list when given an empty list" do
      assert Helper.active_and_founding_sponsors([]) == []
    end
  end

  describe "active_non_founding_sponsors/1" do
    test "reduces to active non-founding sponsors" do
      sponsors = [
        build(:sponsor, %{active: true}),
        build(:sponsor, %{active: false}),
        build(:sponsor, %{active: true, is_founding_sponsor: true})
      ]

      count =
        sponsors
        |> Helper.active_non_founding_sponsors()
        |> Enum.count()

      assert count == 1
    end

    test "returns an empty list when given an empty list" do
      assert Helper.active_non_founding_sponsors([]) == []
    end
  end

  describe "founding_non_active_sponsors/1" do
    test "reduces to founding non-active sponsors" do
      sponsors = [
        build(:sponsor, %{active: true}),
        build(:sponsor, %{active: false}),
        build(:sponsor, %{active: false, is_founding_sponsor: true})
      ]

      count =
        sponsors
        |> Helper.founding_non_active_sponsors()
        |> Enum.count()

      assert count == 1
    end

    test "returns an empty list when given an empty list" do
      assert Helper.founding_non_active_sponsors([]) == []
    end
  end

  describe "active_sponsors/1" do
    test "reduces to any active sponsors" do
      sponsors = [
        build(:sponsor, %{active: true, is_founding_sponsor: true}),
        build(:sponsor, %{active: false, is_founding_sponsor: true})
      ]

      count =
        sponsors
        |> Helper.active_sponsors()
        |> Enum.count()

      assert count == 1
    end

    test "returns an empty list when given an empty list" do
      assert Helper.active_sponsors([]) == []
    end
  end

  describe "founding_sponsors/1" do
    test "reduces to any founding sponsors" do
      sponsors = [
        build(:sponsor, %{active: true, is_founding_sponsor: true}),
        build(:sponsor, %{active: false, is_founding_sponsor: true})
      ]

      count =
        sponsors
        |> Helper.founding_sponsors()
        |> Enum.count()

      assert count == 2
    end

    test "returns an empty list when given an empty list" do
      assert Helper.founding_sponsors([]) == []
    end
  end
end
