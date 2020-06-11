defmodule TestList do
  def empty?([]), do: true
  def empty?([_|_]), do: false
end

IO.puts(TestList.empty?([1])) #=> false
IO.puts(TestList.empty?([])) #=> true

defmodule Polymorphic do
  def double(x) when is_number(x), do: 2 * x
  def double(x) when is_binary(x), do: x <> x
end

IO.puts(Polymorphic.double(3)) #=> 6
IO.puts(Polymorphic.double("bibble")) #=> bibblebibble

# recursion based on multiclauses:

defmodule Fact do
  def fact(0), do: 1
  def fact(n), do: n * fact(n - 1)
end

IO.puts(Fact.fact(9)) #=> 362880


defmodule ListHelper do
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)
end

IO.puts(ListHelper.sum([])) #=> 0
IO.puts(ListHelper.sum([1, 2, 3])) #=> 6


# error handling / reporting

defmodule LinesCounter do
  def count(path) do
    File.read(path)
    |> lines_num
  end

  defp lines_num({:ok, contents}) do
    contents
    |> String.split("\n")
    |> length
  end

  defp lines_num(error), do: error
end

IO.inspect(LinesCounter.count("conditionals.ex")) # => 53
IO.inspect(LinesCounter.count("nonexistent_file")) # => {:error, :enoent}


# classical branching constructs

a = 5
if a > 1, do: IO.puts("big number!!") #=> "big number!!"
a = 1
b = (if a > 1, do: IO.puts "big number!!")
IO.inspect(b) #=> nil

if a > 1, do: IO.puts("big number!!"), else: IO.puts("small number") #=> "small number"
unless a > 1, do: IO.puts("small number"), else: IO.puts("big number!!") #=> "small number"


# cond

defmodule Max do
  def max(a, b) do
    cond do
      a >= b -> a
      true -> b # default clause, always last & set to true so condition is always met if previously not met
    end
  end
end

IO.puts(Max.max(9, 7)) #=> 9
IO.puts(Max.max(7, 9)) #=> 9
IO.puts(Max.max(9, 9)) #=> 9


# case (deals with pattern matching, and similar to multiclause function)

defmodule Min do
  def min(a, b) do
    case a <= b do
      true -> a
      false -> b
    end
  end
end

IO.puts(Min.min(9, 7)) #=> 7
IO.puts(Min.min(7, 9)) #=> 7
IO.puts(Min.min(7, 7)) #=> 7

# multiclause equivalent
defmodule Min2 do
  def min2(a, b) when a <= b, do: a
  def min2(a, b) when a > b, do: b
end

IO.puts(Min2.min2(9, 6)) #=> 6
IO.puts(Min2.min2(6, 9)) #=> 6
IO.puts(Min2.min2(6, 6)) #=> 6
