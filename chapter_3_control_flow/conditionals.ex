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

IO.puts(Fact.fact(9)) = #=> 362880
