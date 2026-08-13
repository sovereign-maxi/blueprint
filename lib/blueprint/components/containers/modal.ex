defmodule Blueprint.Components.Containers.Modal do
  @moduledoc """
  Fixed-position overlay dialog. Two usage shapes:

    * Scaffolded — pass `title` (and optionally `title_id`) and the
      modal renders `.bp-box` + `.bp-panel-header` + `.bp-panel-body`
      around the slot.

    * Composable — omit `title` and the slot is placed directly
      inside a bare `.bp-box`. The caller composes its own `<.panel>`
      or custom chrome, useful when the header needs per-state
      conditional content.

  `on_close` fires on backdrop click. Callers should also render an
  explicit CLOSE button inside the modal for keyboard parity.
  """

  use Phoenix.Component

  attr(:title, :string, default: nil)
  attr(:title_id, :string, default: "modal-title")
  attr(:labelledby, :string, default: nil, doc: "aria-labelledby override for composable shape")
  attr(:on_close, :string, required: true)
  attr(:card_class, :string, default: nil)
  slot(:header_action, doc: "optional right-side element in the scaffolded header")
  slot(:inner_block, required: true)

  def modal(assigns) do
    ~H"""
    <div class="bp-modal-overlay">
      <div
        class={["bp-box bp-modal-card", @card_class]}
        role="dialog"
        aria-modal="true"
        aria-labelledby={@labelledby || @title_id}
        phx-click-away={@on_close}
      >
        <%= if @title do %>
          <div class="bp-panel-header">
            <h2 id={@title_id} class="bp-panel-title">{@title}</h2>
            {render_slot(@header_action)}
          </div>
          <div class="bp-panel-body bp-stack">
            {render_slot(@inner_block)}
          </div>
        <% else %>
          {render_slot(@inner_block)}
        <% end %>
      </div>
    </div>
    """
  end
end
