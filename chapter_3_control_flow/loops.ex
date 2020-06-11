# loops using recursion

defmodule NatNums do
  def print(1), do: IO.puts(1)

  def print(n) do
    if is_number(n) && is_integer(n) && n > 0 do
      print(n - 1)
      IO.puts(n)
    else
      IO.puts("n must be a positive integer")
    end
  end
end

NatNums.print(7) #=> 1 2 3 4 5 6 7
NatNums.print(2.2) #=> n must be a positive integer
NatNums.print(-5) #=> n must be a positive integer
NatNums.print("A") #=> n must be a positive integer

# v2, using guards:

defmodule NatNums2 do
  def print(1), do: IO.puts(1)

  def print(n) when is_number(n) and is_integer(n) and n > 0 do
    print(n - 1)
    IO.puts(n)
  end

  def print(_n) do
    IO.puts("n must be a positive integer")
  end
end

NatNums2.print(7) #=> 1 2 3 4 5 6 7
NatNums2.print(2.2) #=> n must be a positive integer
NatNums2.print(-5) #=> n must be a positive integer
NatNums2.print("A") #=> n must be a positive integer


# memory considerations: simple recursion can be problematic as a looping
# construct: consider the following example:

defmodule ListHelper do
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)
end

IO.puts(ListHelper.sum([])) #=> 0
IO.puts(ListHelper.sum([1, 2, 3])) #=> 6

# The recursive loop above could completely consume available memory,
# given a long enough list to sum! Solution:


# Tail function calls

# If the last thing a function does is call another function (or itself),
# you’re dealing with a tail call:
#
#   def original_fun(...) do
#     ...
#     another_fun(...)
#   end
#
# Erlang optimizes tail calls such that they do not consume additional memory

defmodule ListHelper do
  def sum(list) do
    do_sum(0, list)
  end

  defp do_sum(current_sum, []) do # matches on an empty list and halts recursion
    current_sum
  end

  defp do_sum(current_sum, [head | tail]) do
    new_sum = head + current_sum   # computes new value of the sum
    do_sum(new_sum, tail)          # tail-recursive call
  end
end

IO.puts(ListHelper.sum([1, 2, 3])) #=> 6

# Note: final do_sum function could be rewritten as:
#
#     defp do_sum(current_sum, [head | tail]) do
#       do_sum(head + current_sum, tail)
#     end

# summary: use tail recursion when unlimited, or relatively large numbers of,
# iterations a possibility. use non-tail for elegance and/ or performance,
# where tail recursion is not indicated.

# practice exercises:

# 1. list_len/1 function that calculates the length of a list

defmodule ListStuff do
  def len(list) do
    count_elems(0, list)
  end

  defp count_elems(current_count, []) do
    current_count
  end

  defp count_elems(current_count, [_head | tail]) do
    count_elems(current_count + 1, tail)
  end
end

IO.puts(ListStuff.len([1, 2, 3, 4])) #=> 4
IO.puts(ListStuff.len([])) #=> 0
