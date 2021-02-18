defmodule PlausibleWeb.Api.ExternalStatsController.BreakdownTest do
  use PlausibleWeb.ConnCase
  import Plausible.TestUtils

  setup [:create_user, :create_new_site, :create_api_key, :use_api_key]

  test "breakdown by visit:source", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        referrer_source: "Google",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        referrer_source: "Google",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        referrer_source: "Twitter",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:source"
      })

    assert json_response(conn, 200) == [
             %{"source" => "Google", "visitors" => 2},
             %{"source" => "Twitter", "visitors" => 1}
           ]
  end

  test "breakdown by visit:country", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview, country_code: "EE", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00]),
      build(:pageview, country_code: "EE", domain: site.domain, timestamp: ~N[2021-01-01 00:25:00]),
      build(:pageview, country_code: "US", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00])
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:country"
      })

    assert json_response(conn, 200) == [
             %{"country" => "EE", "visitors" => 2},
             %{"country" => "US", "visitors" => 1}
           ]
  end

  test "breakdown by visit:referrer", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        referrer: "https://ref.com",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        referrer: "https://ref.com",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        referrer: "https://ref2.com",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:referrer"
      })

    assert json_response(conn, 200) == [
             %{"referrer" => "https://ref.com", "visitors" => 2},
             %{"referrer" => "https://ref2.com", "visitors" => 1}
           ]
  end

  test "breakdown by visit:utm_medium", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        utm_medium: "Search",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        utm_medium: "Search",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        utm_medium: "Social",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:utm_medium"
      })

    assert json_response(conn, 200) == [
             %{"utm_medium" => "Search", "visitors" => 2},
             %{"utm_medium" => "Social", "visitors" => 1}
           ]
  end

  test "breakdown by visit:utm_source", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        utm_source: "Google",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        utm_source: "Google",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        utm_source: "Twitter",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:utm_source"
      })

    assert json_response(conn, 200) == [
             %{"utm_source" => "Google", "visitors" => 2},
             %{"utm_source" => "Twitter", "visitors" => 1}
           ]
  end

  test "breakdown by visit:utm_campaign", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        utm_campaign: "ads",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        utm_campaign: "ads",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        utm_campaign: "profile",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:utm_campaign"
      })

    assert json_response(conn, 200) == [
             %{"utm_campaign" => "ads", "visitors" => 2},
             %{"utm_campaign" => "profile", "visitors" => 1}
           ]
  end

  test "breakdown by visit:device", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        screen_size: "Desktop",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        screen_size: "Desktop",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        screen_size: "Mobile",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:device"
      })

    assert json_response(conn, 200) == [
             %{"device" => "Desktop", "visitors" => 2},
             %{"device" => "Mobile", "visitors" => 1}
           ]
  end

  test "breakdown by visit:os", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        operating_system: "Mac",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        operating_system: "Mac",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        operating_system: "Windows",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:os"
      })

    assert json_response(conn, 200) == [
             %{"os" => "Mac", "visitors" => 2},
             %{"os" => "Windows", "visitors" => 1}
           ]
  end

  test "breakdown by visit:os_version", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        operating_system_version: "10.5",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        operating_system_version: "10.5",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        operating_system_version: "10.6",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:os_version"
      })

    assert json_response(conn, 200) == [
             %{"os_version" => "10.5", "visitors" => 2},
             %{"os_version" => "10.6", "visitors" => 1}
           ]
  end

  test "breakdown by visit:browser", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview, browser: "Firefox", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00]),
      build(:pageview, browser: "Firefox", domain: site.domain, timestamp: ~N[2021-01-01 00:25:00]),
      build(:pageview, browser: "Safari", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00])
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:browser"
      })

    assert json_response(conn, 200) == [
             %{"browser" => "Firefox", "visitors" => 2},
             %{"browser" => "Safari", "visitors" => 1}
           ]
  end

  test "breakdown by visit:browser_version", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview,
        browser_version: "56",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      ),
      build(:pageview,
        browser_version: "56",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:25:00]
      ),
      build(:pageview,
        browser_version: "57",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "visit:browser_version"
      })

    assert json_response(conn, 200) == [
             %{"browser_version" => "56", "visitors" => 2},
             %{"browser_version" => "57", "visitors" => 1}
           ]
  end

  test "breakdown by event:page", %{conn: conn, site: site} do
    populate_stats([
      build(:pageview, pathname: "/", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00]),
      build(:pageview, pathname: "/", domain: site.domain, timestamp: ~N[2021-01-01 00:25:00]),
      build(:pageview,
        pathname: "/plausible.io",
        domain: site.domain,
        timestamp: ~N[2021-01-01 00:00:00]
      )
    ])

    conn =
      get(conn, "/api/v1/stats/breakdown", %{
        "site_id" => site.domain,
        "period" => "day",
        "date" => "2021-01-01",
        "property" => "event:page"
      })

    assert json_response(conn, 200) == [
             %{"page" => "/", "visitors" => 2},
             %{"page" => "/plausible.io", "visitors" => 1}
           ]
  end

  describe "pagination" do
    test "can limit results", %{conn: conn, site: site} do
      populate_stats([
        build(:pageview, pathname: "/a", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00]),
        build(:pageview, pathname: "/b", domain: site.domain, timestamp: ~N[2021-01-01 00:25:00]),
        build(:pageview, pathname: "/c", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00])
      ])

      conn =
        get(conn, "/api/v1/stats/breakdown", %{
          "site_id" => site.domain,
          "period" => "day",
          "date" => "2021-01-01",
          "property" => "event:page",
          "limit" => 2
        })

      res = json_response(conn, 200)
      assert Enum.count(res) == 2
    end

    test "can paginate results", %{conn: conn, site: site} do
      populate_stats([
        build(:pageview, pathname: "/a", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00]),
        build(:pageview, pathname: "/b", domain: site.domain, timestamp: ~N[2021-01-01 00:25:00]),
        build(:pageview, pathname: "/c", domain: site.domain, timestamp: ~N[2021-01-01 00:00:00])
      ])

      conn =
        get(conn, "/api/v1/stats/breakdown", %{
          "site_id" => site.domain,
          "period" => "day",
          "date" => "2021-01-01",
          "property" => "event:page",
          "limit" => 2,
          "page" => 2
        })

      res = json_response(conn, 200)
      assert Enum.count(res) == 1
    end
  end

  describe "metrics" do
    test "all metrics for breakdown by visit prop", %{conn: conn, site: site} do
      populate_stats([
        build(:pageview,
          user_id: 1,
          referrer_source: "Google",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:00:00]
        ),
        build(:pageview,
          user_id: 1,
          referrer_source: "Google",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:10:00]
        ),
        build(:pageview,
          referrer_source: "Google",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:25:00]
        ),
        build(:pageview,
          referrer_source: "Twitter",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:00:00]
        )
      ])

      conn =
        get(conn, "/api/v1/stats/breakdown", %{
          "site_id" => site.domain,
          "period" => "day",
          "date" => "2021-01-01",
          "property" => "visit:source",
          "metrics" => "visitors,pageviews,bounce_rate,visit_duration"
        })

      assert json_response(conn, 200) == [
               %{
                 "source" => "Google",
                 "visitors" => 2,
                 "bounce_rate" => 50,
                 "visit_duration" => 300,
                 "pageviews" => 3
               },
               %{
                 "source" => "Twitter",
                 "visitors" => 1,
                 "bounce_rate" => 100,
                 "visit_duration" => 0,
                 "pageviews" => 1
               }
             ]
    end

    test "all metrics for breakdown by event prop", %{conn: conn, site: site} do
      populate_stats([
        build(:pageview,
          user_id: 1,
          pathname: "/",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:00:00]
        ),
        build(:pageview,
          user_id: 1,
          pathname: "/plausible.io",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:10:00]
        ),
        build(:pageview, pathname: "/", domain: site.domain, timestamp: ~N[2021-01-01 00:25:00]),
        build(:pageview,
          pathname: "/plausible.io",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:00:00]
        )
      ])

      conn =
        get(conn, "/api/v1/stats/breakdown", %{
          "site_id" => site.domain,
          "period" => "day",
          "date" => "2021-01-01",
          "property" => "event:page",
          "metrics" => "visitors,pageviews,bounce_rate,visit_duration"
        })

      assert json_response(conn, 200) == [
               %{
                 "page" => "/",
                 "visitors" => 2,
                 "bounce_rate" => 50,
                 "visit_duration" => 300,
                 "pageviews" => 2
               },
               %{
                 "page" => "/plausible.io",
                 "visitors" => 2,
                 "bounce_rate" => 100,
                 "visit_duration" => 0,
                 "pageviews" => 2
               }
             ]
    end

    test "just bounce rate for event:page", %{conn: conn, site: site} do
      populate_stats([
        build(:pageview,
          user_id: 1,
          pathname: "/",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:00:00]
        ),
        build(:pageview,
          user_id: 1,
          pathname: "/plausible.io",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:10:00]
        ),
        build(:pageview, pathname: "/", domain: site.domain, timestamp: ~N[2021-01-01 00:25:00]),
        build(:pageview,
          pathname: "/plausible.io",
          domain: site.domain,
          timestamp: ~N[2021-01-01 00:00:00]
        )
      ])

      conn =
        get(conn, "/api/v1/stats/breakdown", %{
          "site_id" => site.domain,
          "period" => "day",
          "date" => "2021-01-01",
          "property" => "event:page",
          "metrics" => "bounce_rate"
        })

      assert json_response(conn, 200) == [
               %{"page" => "/", "bounce_rate" => 50},
               %{"page" => "/plausible.io", "bounce_rate" => 100}
             ]
    end
  end
end