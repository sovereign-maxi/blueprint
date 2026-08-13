defmodule Blueprint.Components.Data.EmptyState do
  @moduledoc "Centred empty-state placeholder. Renders `<div class=\"bp-empty-state\">`."

  use Phoenix.Component

  attr(:message, :string, required: true)

  def empty_state(assigns) do
    ~H"""
    <div class="bp-empty-state">{@message}</div>
    """
  end
end
