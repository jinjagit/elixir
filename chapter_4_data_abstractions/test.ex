defmodule Positives2 do
  def positive(list \\ []), do: build_list(list, [])

  defp build_list([], result), do: Enum.reverse(result)

  defp build_list([head | tail], result) do
    if head > 0 do
      build_list(tail, [head | result])
    else
      build_list(tail, result)
    end
  end
end

defmodule Count do
  def count(entries \\ %{}) do
    # real version needs to extract entries here
    count_next(entries, 0)
  end

  defp count_step(entries, nil, count), do: {:ok, count}
  defp count_step(entries, pair, count) do
    {first_key, _val} = pair
    entries = Map.delete(entries, first_key)
    count = count + 1
    IO.puts(count)
    count_next(entries, count)
  end

  defp count_next(entries, count) do
    pair = Enum.at(entries, 0, nil)
    count_step(entries, pair, count)
  end

  def member?(entries, element) do
    if Map.has_key?(entries, element) === true do
      {:ok, true}
    else
      {:ok, false}
    end
  end


end



map = %{3 => %{a: 3}, 4 => %{b: 4}}

IO.inspect(map)

IO.inspect(Count.count(map))

empty = %{}
IO.inspect(Count.count(empty))

IO.inspect(Count.member?(map, 1))
IO.inspect(Count.member?(map, 3))

#{a, _b} = Enum.at(map, 0, nil)

#IO.inspect(a)

#map = Map.delete(map, a)

#IO.inspect(map)



IO.inspect(
 Enum.reduce([1, 2, 4], 0, &(&1 + &2))
)

IO.inspect(
 Enum.reduce(map, 0, &(&1 + &2))
)

defimpl Enumerable, for: TodoList do
  def count(todo_list \\ %{}) do
    count_next(todo_list.entries, 0)
  end

  defp count_step(_entries, nil, count), do: {:ok, count}
  defp count_step(entries, pair, count) do
    {first_key, _val} = pair
    entries = Map.delete(entries, first_key)
    count = count + 1
    IO.puts(count)
    count_next(entries, count)
  end

  defp count_next(entries, count) do
    pair = Enum.at(entries, 0, nil)
    count_step(entries, pair, count)
  end


  def member?(todo_list, element) do
    if Map.has_key?(todo_list.entries, element) === true do
      {:ok, true}
    else
      {:ok, false}
    end
  end


  def slice(_todo_list), do: {:error, __MODULE__}

  def reduce(todo_list, acc \\ 0, acc_fn) do
    Enum.reduce(todo_list.entries, acc, acc_fn)
  end
end
