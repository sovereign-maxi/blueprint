defmodule Blueprint.Components.Layout.Announcements do
  @moduledoc """
  Stack of warning / info / critical banners at the top of a page.

  Messages render ESCAPED by default — announcement text is plain text,
  so user-influenced content (a pseudonym, an address, an error string)
  can never become markup. To render intentional HTML in an item, opt in
  per item with `html: true`:

      %{variant: "critical", message: "Halted: <a href=\"/admin\">details</a>", html: true}

  Only pass `html: true` for strings the product built itself.
  """

  use Phoenix.Component

  attr(:items, :list, required: true)

  def announcements(assigns) do
    ~H"""
    <div :if={@items != []} class="bp-announcements">
      <div :for={item <- @items} class={"bp-announcement #{item[:variant] || "warning"}"}>
        <%= if item[:html] do %>
          {Phoenix.HTML.raw(item.message)}
        <% else %>
          {item.message}
        <% end %>
      </div>
    </div>
    """
  end
end
