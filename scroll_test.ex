{:ok, pid} = Elastic.Scroller.start_link(%{index: "answer", keepalive: "10s"})
Elastic.Scroller.clear(pid) |> IO.inspect
Elastic.Scroller.next_page(pid) |> IO.inspect
