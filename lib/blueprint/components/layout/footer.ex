defmodule Blueprint.Components.Layout.Footer do
  @moduledoc "Sticky footer with status pips (ok/degraded/critical/offline) + commit hash."

  use Phoenix.Component

  attr(:pips, :list, required: true)
  attr(:commit_hash, :string, default: "dev")

  def footer(assigns) do
    ~H"""
    <footer class="bp-footer">
      <div class="bp-footer-pips" role="status" aria-label="System status">
        <div
          :for={pip <- @pips}
          class="bp-footer-pip"
          title={pip.label}
          aria-label={"#{pip.label}: #{pip.status}"}
        >
          <span class={"bp-pip-dot #{pip_dot_class(pip.status)}"} aria-hidden="true"></span>
        </div>
      </div>
      <div class="bp-footer-right">
        <span class="bp-footer-commit"><span>{@commit_hash}</span></span>
      </div>
    </footer>
    """
  end

  defp pip_dot_class(:ok), do: "ok"
  defp pip_dot_class(:degraded), do: "degraded"
  defp pip_dot_class(:critical), do: "critical"
  defp pip_dot_class(:offline), do: "offline"
  defp pip_dot_class(_), do: ""
end
