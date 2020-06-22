run_query = fn(query_def) ->
  :timer.sleep(2000)
  IO.puts "#{query_def} result"
end

# this takes 10 seconds to run 5 queries sequentially:
#1..5 |> Enum.map(&run_query.("query #{&1}"))

#=> query 1 result
#=> query 2 result
#=> query 3 result
#=> query 4 result
#=> query 5 result



async_query = fn(query_def) ->
  spawn(fn -> IO.puts(run_query.(query_def)) end)
end

# this takes 2 seconds to run 5 queries concurently:
#1..5 |> Enum.map(&async_query.("async query #{&1}"))

#=> async query 1 result
#=> async query 2 result
#=> async query 3 result
#=> async query 4 result
#=> async query 5 result
#=> ok
#=> ok
#=> ok
#=> ok
#=> ok


# server processes:

# A server process is an informal name for a process that runs for a long
# time (or forever) and can handle various requests (messages).

# Note: I need to use send() & loop(), rather than send & loop as in the
# book example. I also added IO.puts to run_query/1.

defmodule DatabaseServer do
  def start do
    spawn(&loop/0)
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  def get_result do
    receive do
      {:query_result, result} -> result
    after 5000 ->
      {:error, :timeout}
    end
  end

  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
    end

    loop()
  end

  defp run_query(query_def) do
    :timer.sleep(2000)
    IO.puts "DatabaseServer: #{query_def} result"
  end
end

server_pid = DatabaseServer.start
DatabaseServer.run_async(server_pid, "query 1")
DatabaseServer.get_result
#=> query 1 result
DatabaseServer.run_async(server_pid, "query 2")
DatabaseServer.get_result
#=> query 2 result
