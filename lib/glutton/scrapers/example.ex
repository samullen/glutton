defmodule Glutton.Scrapers.Example do
  alias Glutton.{URLQueue, URLRegistry}
  alias Wallaby.{Browser, Element, Query}

  @doc """
  Initializes the scraper by pushing the starting URL into the URL queue.
  """
  def init() do
    URLQueue.push(%{
      url: "https://www.iana.org/help/example-domains",
      module: __MODULE__
    })
  end

  @doc """
  Scrapes the given URL, processes links on the page, and stores them in the
  URL queue.
  """
  def scrape(url) do
    session()
    |> Browser.visit(url)
    |> process_links()
    |> process_page(url)
    |> Wallaby.end_session() # Clean up the session
  end

  @doc """
  Returns a Wallaby session
  """
  defp session() do
    {:ok, session} = Wallaby.start_session(
      capabilities: %{
        chromeOptions: %{
          args: [
                "--headless",
                "--no-sandbox",
                "window-size=1280,800",
                "--fullscreen",
                "--disable-gpu",
                "--disable-dev-shm-usage"
          ]
        }
      }
    )

    session
  end

  @doc """
  Processes all links matching the css_selectors on the page
  """
  defp process_links(session) do
    css_selectors = "td a, li a"

    session
    |> Browser.all(Query.css(css_selectors, minimum: 0))
    |> Enum.each(&store_link/1)

    session
  end

  @doc """
  Processes the page (currently just logs the URL)
  """
  defp process_page(session, url) do
    IO.inspect "Processing page: #{url}"
    session
  end

  @doc """
  Stores the link if it matches certain criteria
  """
  defp store_link(element) do
    element
    |> Element.attr("href")
    |> _store_link()
  end

  @doc """
  Helper function to store links that match specific patterns
  """
  defp _store_link("https://www.iana.org/" <> _rest = url) do
    url_item = %{
      url: url,
      module: __MODULE__
    }

    case URLRegistry.registered?(url_item) do
      true ->
        :ok
      false ->
        IO.inspect url_item
        URLRegistry.register(url_item)
        URLQueue.push(url_item)
    end
  end

  @doc """
  Helper function for links that do not match specific patterns
  """
  defp _store_link(url) do
    IO.inspect url, label: "Some other link"
    :ok
  end
end
