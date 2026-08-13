defmodule Blueprint.FormatHelpersTest do
  use ExUnit.Case, async: true

  alias Blueprint.FormatHelpers

  test "format_sats adds commas and handles zero" do
    assert FormatHelpers.format_sats(0) == "0"
    assert FormatHelpers.format_sats(250_000) == "250,000"
    assert FormatHelpers.format_sats(1_234_567_890) == "1,234,567,890"
  end

  test "format_sats never renders a silent zero for non-integers" do
    assert FormatHelpers.format_sats(12.5) == "12.5"
    assert FormatHelpers.format_sats("500") == "500"
  end

  test "format_number adds commas, passes through others" do
    assert FormatHelpers.format_number(2847) == "2,847"
    assert FormatHelpers.format_number("n/a") == "n/a"
  end

  test "format_compact_amount covers each magnitude band" do
    assert FormatHelpers.format_compact_amount(0, "USDT") == "0 USDT"
    assert FormatHelpers.format_compact_amount(123_450_000, "USDT") == "1.23 USDT"
    assert FormatHelpers.format_compact_amount(5_000_000_000_000, "XMR") == "50.0k XMR"
    assert FormatHelpers.format_compact_amount(250_000_000_000_000, "USDT") == "2.5M USDT"
  end

  test "format_duration" do
    assert FormatHelpers.format_duration(0) == "--"
    assert FormatHelpers.format_duration(45_000) == "45s"
    assert FormatHelpers.format_duration(840_000) == "14 min"
  end

  test "format_pct" do
    assert FormatHelpers.format_pct(0) == "--"
    assert FormatHelpers.format_pct(0.9997) == "99.97%"
  end

  test "relative_time past buckets" do
    now = ~U[2026-03-24 04:21:00Z]
    assert FormatHelpers.relative_time(~U[2026-03-24 04:20:57Z], now) == "just now"
    assert FormatHelpers.relative_time(~U[2026-03-24 04:20:30Z], now) == "30s ago"
    assert FormatHelpers.relative_time(~U[2026-03-24 04:16:00Z], now) == "5m ago"
    assert FormatHelpers.relative_time(~U[2026-03-23 04:21:00Z], now) == "1d ago"
    assert FormatHelpers.relative_time(~U[2026-03-01 04:21:00Z], now) == "2026-03-01"
  end

  test "time_until handles both directions" do
    now = ~U[2026-03-24 04:21:00Z]
    assert FormatHelpers.time_until(~U[2026-03-24 04:21:00Z], now) == "now"
    assert FormatHelpers.time_until(~U[2026-03-24 04:24:00Z], now) == "3m"
    assert FormatHelpers.time_until(~U[2026-03-24 02:21:00Z], now) == "2h ago"
  end
end
