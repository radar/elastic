defmodule Elastic.Scroller do
  alias Elastic.Index
  alias Elastic.Scroll

  use GenServer

  def start_link(opts = %{index: index}) do
    opts = opts
    |> Map.put_new(:body, %{})
    |> Map.put_new(:size, 100)
    |> Map.put_new(:keepalive, "1m")
    |> Map.put(:index, index)
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state = %{index: index, body: body, size: size, keepalive: keepalive}) do
    scroll = Scroll.start(%{
      index: index,
      body: body,
      size: size,
      keepalive: keepalive
    })

    case scroll do
      {:ok, 200, %{"_scroll_id" => scroll_id, "hits" => %{"hits" => hits}} = result} ->
        {:ok, Map.merge(state, %{scroll_id: scroll_id, hits: hits})}
      {:error, _status, error} ->
        {:stop, inspect(error)}
    end
  end

  def results(pid) do
    GenServer.call(pid, :results)
  end

  def next_page(pid) do
    GenServer.call(pid, :next_page)
  end

  def scroll_id(pid) do
    GenServer.call(pid, :scroll_id)
  end

  def index(pid) do
    GenServer.call(pid, :index)
  end

  def body(pid) do
    GenServer.call(pid, :body)
  end

  def keepalive(pid) do
    GenServer.call(pid, :keepalive)
  end

  def size(pid) do
    GenServer.call(pid, :size)
  end

  def clear(pid) do
    GenServer.call(pid, :clear)
  end

  def handle_call(:results, _from, state = %{hits: hits}) do
    {:reply, hits, state}
  end

  def handle_call(:next_page, _from, state = %{index: index, body: body, keepalive: keepalive, scroll_id: scroll_id}) do
    scroll = %{
      index: index,
      body: body,
      scroll_id: scroll_id,
      keepalive: keepalive
    }

    case scroll |> Scroll.next do
      {:ok, 200, %{
      "_scroll_id" => id,
      "hits" => %{"hits" => hits}}} ->
        state = state |> Map.merge(%{scroll_id: id, hits: hits})
        {:reply, {:ok, id}, state}
      {:error, 404, error} ->
        {:reply, {:error, :search_context_not_found, inspect(error)}, state}
      {:error, _, error} ->
        {:reply, {:error, inspect(error)}, state}
    end
  end

  def handle_call(:scroll_id, _from, state = %{scroll_id: scroll_id}) do
    {:reply, scroll_id, state}
  end

  def handle_call(:size, _from, state = %{size: size}) do
    {:reply, size, state}
  end

  def handle_call(:index, _from, state = %{index: index}) do
    {:reply, Index.name(index), state}
  end

  def handle_call(:body, _from, state = %{body: body}) do
    {:reply, body, state}
  end

  def handle_call(:keepalive, _from, state = %{keepalive: keepalive}) do
    {:reply, keepalive, state}
  end

  def handle_call(:clear, _from, state = %{scroll_id: scroll_id}) do
    response = Scroll.clear([scroll_id])
    {:reply, response, state}
  end
end
