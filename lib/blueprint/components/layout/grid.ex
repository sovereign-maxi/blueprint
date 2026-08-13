defmodule Blueprint.Components.Layout.Grid do
  @moduledoc ~S(CSS Grid wrapper. `cols` accepts "2", "3", "3-2", "4", "wallet".)

  use Phoenix.Component

  attr(:cols, :string, default: "2")
  slot(:inner_block, required: true)

  def grid(assigns) do
    ~H"""
    <div class={"bp-grid cols-#{@cols}"}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
