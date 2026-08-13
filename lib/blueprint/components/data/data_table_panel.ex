defmodule Blueprint.Components.Data.DataTablePanel do
  @moduledoc """
  Panel composition: `.panel` + optional `.bp-filter-row` slot +
  `.bp-table-scroll` (with empty-state fallback) + optional
  `.bp-paginator`. Kills the every-list-page boilerplate.

  Rows come from the caller via `:table` slot. When `rows == []`,
  the empty-state slot is rendered instead. If `total > per_page`,
  the paginator renders in the panel footer wired to `paginate_event`.
  """

  use Phoenix.Component

  import Blueprint.Components.Containers.Panel
  import Blueprint.Components.Data.Paginator
  import Blueprint.Components.Data.TableEmptyState

  attr(:title, :string, required: true)
  attr(:rows, :list, required: true)
  attr(:empty_message, :string, required: true)
  attr(:page, :integer, default: 1)
  attr(:per_page, :integer, default: 25)
  attr(:total, :integer, default: nil, doc: "if nil, defaults to length(rows)")
  attr(:paginate_event, :string, default: "paginate")
  attr(:paginate_label, :string, default: "results")
  attr(:panel_class, :string, default: "")

  slot(:header_action, doc: "action link(s) in the panel header — passed through to <.panel>")

  slot(:filter_row,
    doc: "optional filter row (categories, status select) between header and table"
  )

  slot(:table, required: true, doc: "the <table> body (rendered when rows != [])")

  def data_table_panel(assigns) do
    assigns = assign_new(assigns, :total, fn -> length(assigns.rows) end)

    ~H"""
    <.panel title={@title} class={@panel_class}>
      <:header_action>{render_slot(@header_action)}</:header_action>

      {render_slot(@filter_row)}

      <div class="bp-table-scroll">
        <.table_empty_state :if={@rows == []} message={@empty_message} />
        {render_slot(@table)}
      </div>

      <.paginator
        page={@page}
        total={@total}
        per_page={@per_page}
        event={@paginate_event}
        label={@paginate_label}
      />
    </.panel>
    """
  end
end
