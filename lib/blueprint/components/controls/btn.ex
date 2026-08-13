defmodule Blueprint.Components.Controls.Btn do
  @moduledoc "Full-width button with variant (primary / danger / muted / default)."

  use Phoenix.Component

  attr(:variant, :string, default: "primary")
  attr(:class, :string, default: "")

  attr(:rest, :global,
    include:
      ~w(type disabled phx-click phx-target phx-value-method phx-value-id id phx-hook data-clipboard-text data-select-target)
  )

  slot(:inner_block, required: true)

  def btn(assigns) do
    ~H"""
    <button class={"bp-btn bp-btn-#{@variant} #{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end
end
