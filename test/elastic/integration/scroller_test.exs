defmodule Elastic.Integration.ScrollTest do
  use Elastic.IntegrationTestCase
  alias Elastic.Scroller

  setup do
    Answer.index(1, %{text: "Hello Earth!"})
    Answer.index(2, %{text: "Hello Mars!"})
    Answer.index(3, %{text: "Hello Jupiter!"})
    Elastic.Index.refresh("answer")
    :ok
  end

  @tag integration: true
  test "starting a new scroll" do
    {:ok, pid} = Scroller.start_link(%{
      index: "answer"
    })
    assert Scroller.index(pid) == "elastic_test_answer"
    assert Scroller.scroll_id(pid)
    assert Scroller.body(pid) == %{}
    assert Scroller.keepalive(pid) == "1m"
  end

  @tag integration: true
  test "starting a new scroll with a body" do
    body =  %{
      query: %{
        match: %{text: "Hello"}
      }
    }

    {:ok, pid} = Scroller.start_link(%{
      index: "answer",
      body: body
    })
    assert Scroller.body(pid) == body
  end

  @tag integration: true
  test "starting a new scroll with a different keepalive" do
    {:ok, pid} = Scroller.start_link(%{
      index: "answer",
      keepalive: "2m"
    })
    assert Scroller.keepalive(pid) == "2m"
  end

  @tag integration: true
  test "starting a new scroll with a different size" do
    {:ok, pid} = Scroller.start_link(%{
      index: "answer",
      size: 200
    })
    assert Scroller.size(pid) == 200
  end

  @tag integration: true
  test "results" do
    {:ok, pid} = Scroller.start_link(%{
      index: "answer",
      size: 1
    })
    # IDs here are returned in a seemingly random, but predicatable order.
    # On my machine, they are id1=2, id2=1 id3=3
    [%{"_id" => id1}] = Scroller.results(pid)
    assert {:ok, _} = Scroller.next_page(pid)
    [%{"_id" => id2}] = Scroller.results(pid)
    assert {:ok, _} = Scroller.next_page(pid)
    [%{"_id" => id3}] = Scroller.results(pid)

    assert id1 != id2
    assert id1 != id3
    assert id2 != id3

    assert {:ok, _} = Scroller.next_page(pid)
    assert Scroller.results(pid) == []
  end

  @tag integration: true
  test "requesting next page after scroll clear returns an error" do
    {:ok, pid} = Scroller.start_link(%{
      index: "answer",
      size: 1,
    })
    Scroller.clear(pid)

    assert {:error, :search_context_not_found, _} = Scroller.next_page(pid)
  end

  @tag integration: true
  describe "init" do
    test "starts the server" do
      assert {:ok, state} = Scroller.init(
        %{
          index: "answer",
          body: %{},
          size: 100,
          keepalive: "1m"
        }
      )
      assert Map.take(state, [:index, :body, :size, :keepalive]) == %{
        index: "answer",
        body: %{},
        size: 100,
        keepalive: "1m"
      }
    end

    test "with an invalid query stops the server" do
      assert {:stop, _} = Scroller.init(
        %{
          index: "answer",
          body: %{"bad" => "body"},
          size: 100,
          keepalive: "1m"
        }
      )
    end
  end
end
