defmodule Blueprint.Components.SafeHref do
  @moduledoc """
  Sanitises caller-supplied hrefs before they reach an `href` attribute.

  Allows relative paths (`/…`, `./…`, `../…`, `#…`) and `http(s)` URLs;
  anything else — `javascript:`, `data:`, `vbscript:`, protocol-relative
  oddballs, nil — degrades to `"#"`. Defense-in-depth for attrs that are
  operator-configured today but could one day carry user data.
  """

  @spec safe_href(term()) :: String.t()
  def safe_href(href) when is_binary(href) do
    trimmed = String.trim_leading(href)

    cond do
      String.starts_with?(trimmed, ["#", "/"]) -> href
      String.match?(trimmed, ~r/\Ahttps?:\/\//i) -> href
      true -> "#"
    end
  end

  def safe_href(_), do: "#"
end
