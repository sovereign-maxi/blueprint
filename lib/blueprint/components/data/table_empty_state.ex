defmodule Blueprint.Components.Data.TableEmptyState do
  @moduledoc """
  Wrapper that pairs with `.bp-table-scroll` — centres the empty
  message vertically inside the scroll container. Composes with
  `Blueprint.Components.EmptyState` internally.

  Empty-state message strings never end with a period — write them
  as bare fragments (e.g. \"No markets yet\").
  """

  use Phoenix.Component

  import Blueprint.Components.Data.EmptyState

  attr(:message, :string, required: true)

  def table_empty_state(assigns) do
    ~H"""
    <div class="bp-empty bp-empty-fill">
      <.empty_state message={@message} />
    </div>
    """
  end
end
