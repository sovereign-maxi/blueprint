defmodule Blueprint.Components.SafetyTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias Blueprint.Components.Layout.Announcements
  alias Blueprint.Components.SafeHref

  test "announcements escape message text by default" do
    html =
      render_component(&Announcements.announcements/1,
        items: [%{message: "<script>alert(1)</script>"}]
      )

    refute html =~ "<script>alert(1)</script>"
    assert html =~ "&lt;script&gt;"
  end

  test "announcements render markup only with explicit html: true opt-in" do
    html =
      render_component(&Announcements.announcements/1,
        items: [%{message: ~s|Halted: <a href="/admin">details</a>|, html: true}]
      )

    assert html =~ ~s|<a href="/admin">details</a>|
  end

  test "safe_href allows relative paths and https, blocks javascript:" do
    assert SafeHref.safe_href("/markets") == "/markets"
    assert SafeHref.safe_href("#top") == "#top"
    assert SafeHref.safe_href("https://example.com/x") == "https://example.com/x"
    assert SafeHref.safe_href("javascript:alert(1)") == "#"
    assert SafeHref.safe_href("data:text/html,<script>") == "#"
    assert SafeHref.safe_href(nil) == "#"
  end
end
