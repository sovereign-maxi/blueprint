defmodule Blueprint.FormatHelpers do
  @moduledoc """
  Shared formatting functions for display values.
  """

  @doc "Format satoshis with comma separators."
  @spec format_sats(integer()) :: String.t()
  def format_sats(0), do: "0"

  def format_sats(amount) when is_integer(amount) do
    amount |> Integer.to_string() |> add_commas()
  end

  # Never render a silent "0" for non-integer input — a wrong zero on a
  # balance cell is how you give a user a heart attack. Fall back to the
  # plain string form so the value is at least visible.
  def format_sats(other), do: to_string(other)

  @doc "Format a number with comma separators."
  @spec format_number(integer()) :: String.t()
  def format_number(n) when is_integer(n) do
    n |> Integer.to_string() |> add_commas()
  end

  def format_number(n), do: to_string(n)

  @doc "Relative time string from a DateTime (past-relative — e.g. \"5m ago\")."
  @spec relative_time(DateTime.t(), DateTime.t()) :: String.t()
  def relative_time(%DateTime{} = dt, %DateTime{} = now) do
    diff = DateTime.diff(now, dt, :second)

    cond do
      diff < 5 -> "just now"
      diff < 60 -> "#{diff}s ago"
      diff < 3_600 -> "#{div(diff, 60)}m ago"
      diff < 86_400 -> "#{div(diff, 3_600)}h #{div(rem(diff, 3_600), 60)}m ago"
      diff < 604_800 -> "#{div(diff, 86_400)}d ago"
      true -> Calendar.strftime(dt, "%Y-%m-%d")
    end
  end

  def relative_time(_, _), do: "--"

  @doc """
  Future-or-past relative time to `target` measured from `now`.
  Positive = time-until, negative = time-since. Compact form suitable
  for table cells and countdowns (e.g. `"3m"`, `"2h 14m"`, `"3d ago"`).
  Symmetric with `relative_time/2` — use `time_until` when the field
  can be either side of `now`, `relative_time` when it's strictly past.
  """
  @spec time_until(DateTime.t(), DateTime.t()) :: String.t()
  def time_until(%DateTime{} = target, %DateTime{} = now) do
    case DateTime.diff(target, now, :second) do
      0 -> "now"
      diff when diff > 0 -> future_label(diff)
      diff -> past_label(-diff)
    end
  end

  def time_until(_, _), do: "--"

  defp future_label(diff) when diff < 60, do: "#{diff}s"
  defp future_label(diff) when diff < 3_600, do: "#{div(diff, 60)}m"

  defp future_label(diff) when diff < 86_400 do
    "#{div(diff, 3_600)}h #{div(rem(diff, 3_600), 60)}m"
  end

  defp future_label(diff), do: "#{div(diff, 86_400)}d"

  defp past_label(diff) when diff < 60, do: "#{diff}s ago"
  defp past_label(diff) when diff < 3_600, do: "#{div(diff, 60)}m ago"
  defp past_label(diff) when diff < 86_400, do: "#{div(diff, 3_600)}h ago"
  defp past_label(diff), do: "#{div(diff, 86_400)}d ago"

  @doc """
  Compact monetary format from an integer fixed-point amount. Divides
  by 10^8 (8-decimal fixed point) and pretty-prints with `k` / `M`
  suffixes above 1000 / 1M. `unit` is appended as a suffix (`"USDT"`,
  `"XMR"`, `"BTC"`, …). Same logic used by every product's sub-nav
  TVL cell.

  ## Examples

      iex> format_compact_amount(0, "USDT")
      "0 USDT"

      iex> format_compact_amount(123_450_000, "USDT")
      "1.23 USDT"

      iex> format_compact_amount(5_000_000_000_000, "XMR")
      "50.0k XMR"
  """
  @spec format_compact_amount(non_neg_integer(), String.t()) :: String.t()
  def format_compact_amount(0, unit), do: "0 #{unit}"

  def format_compact_amount(amount, unit) when is_integer(amount) and amount > 0 do
    value = amount / 100_000_000

    cond do
      value >= 1_000_000 ->
        :io_lib.format("~.1fM ~s", [value / 1_000_000, unit]) |> IO.iodata_to_binary()

      value >= 1_000 ->
        :io_lib.format("~.1fk ~s", [value / 1_000, unit]) |> IO.iodata_to_binary()

      value >= 1 ->
        :io_lib.format("~.2f ~s", [value, unit]) |> IO.iodata_to_binary()

      true ->
        :io_lib.format("~.4f ~s", [value, unit]) |> IO.iodata_to_binary()
    end
  end

  def format_compact_amount(_, _), do: "--"

  @doc "Format a duration in milliseconds to a human-readable string."
  @spec format_duration(non_neg_integer()) :: String.t()
  def format_duration(0), do: "--"
  def format_duration(ms) when is_integer(ms) and ms < 60_000, do: "#{div(ms, 1_000)}s"
  def format_duration(ms) when is_integer(ms), do: "#{div(ms, 60_000)} min"
  def format_duration(_), do: "--"

  @doc "Format a percentage from a float ratio (0.0 - 1.0), two decimals."
  @spec format_pct(number()) :: String.t()
  def format_pct(0), do: "--"
  def format_pct(ratio) when is_float(ratio), do: "#{Float.round(ratio * 100, 2)}%"
  def format_pct(_), do: "--"

  @doc "Format a timestamp as HH:MM UTC."
  @spec format_time(DateTime.t()) :: String.t()
  def format_time(%DateTime{} = dt), do: Calendar.strftime(dt, "%H:%M")
  def format_time(_), do: "--:--"

  @doc "Get the short git commit hash. Computed once at compile time."
  @spec commit_hash() :: String.t()
  # Cached at compile time to avoid spawning an OS process on every call.
  @cached_commit_hash (case System.cmd("git", ["rev-parse", "--short", "HEAD"],
                              stderr_to_stdout: true
                            ) do
                         {hash, 0} -> String.trim(hash)
                         _ -> "dev"
                       end)

  def commit_hash, do: @cached_commit_hash

  # ─────────────────────────────────────────────────────────────
  # Private
  # ─────────────────────────────────────────────────────────────

  defp add_commas(str) do
    str
    |> String.reverse()
    |> String.replace(~r/(\d{3})(?=\d)/, "\\1,")
    |> String.reverse()
  end
end
