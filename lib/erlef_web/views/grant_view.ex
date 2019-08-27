defmodule ErlefWeb.GrantView do
  use ErlefWeb, :view

  def grant_type_select(form) do
    select(
      form,
      :grant_type,
      [
        [key: "--", value: "", "data-type": "none", "data-requires-coc": "false"],
        [
          key: "Conference",
          value: "conference",
          "data-type": "conference",
          "data-requires-coc": "true"
        ],
        [
          key: "Development Work",
          value: "Development Work",
          "data-type": "devel_work",
          "data-requires-coc": "false"
        ],
        [
          key: "Event Site Subscription",
          value: "Event Site Subscription",
          "data-type": "event_site_sub",
          "data-requires-coc": "false"
        ],
        [
          key: "Kids Coding Camp",
          value: "Kids Coding Camp",
          "data-type": "kids_camp",
          "data-requires-coc": "false"
        ],
        [key: "Sprint", value: "Sprint", "data-type": "sprint", "data-requires-coc": "false"],
        [
          key: "Training Program",
          value: "Training Program",
          "data-type": "training",
          "data-requires-coc": "false"
        ],
        [
          key: "Workshop-Education",
          value: "Workshop-Education",
          "data-type": "workshop-edu",
          "data-requires-coc": "true"
        ],
        [
          key: "Workshop-Women",
          value: "Workshop-Women",
          "data-type": "workshop-women",
          "data-requires-coc": "true"
        ],
        [key: "Other", value: "Other", "data-type": "other", "data-requires-coc": "false"]
      ],
      id: "grant_type",
      class: "form-control"
    )
  end

  def payment_method_select(form) do
    select(
      form,
      :payment_method,
      [[key: "--", value: ""], "Paypal", "Zelle", "Check", "Wire"],
      class: "form-control",
      required: "true"
    )
  end
end
