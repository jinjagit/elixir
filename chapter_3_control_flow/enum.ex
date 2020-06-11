# A higher-order function is a fancy name for a function that takes function(s)
# as its input and/or returns function(s). The word function here means
# function value.

# The function Enum.each/2 takes an enumerable (in this case, a list)
# and a lambda. It iterates through the enumerable, calling the lambda for
# each of its elements. Because Enum.each/2 takes a lambda as its input,
# it’s called a higher-order function.

Enum.each(
  [1, 2, 3],
  fn(x) -> IO.puts(x) end # the lambda passed in to Enum.each/2
) #=> 1 2 3

# Enum.map/2 - useful for 1:1 transformation of a list

IO.inspect(
  Enum.map(
    [1, 2, 3],
    fn(x) -> 2 * x end
  )
) #=> [2, 4, 6]

# denser version:
IO.inspect(
  Enum.map([1, 2, 3], &(2 * &1)) # Note nth argument (not indexed from 0)
) #=> [2, 4, 6]

# Enum.filter/2

IO.inspect(
  Enum.filter(
    [1, 2, 3],
    fn(x) -> rem(x, 2) == 1 end
  )
) #=> [1, 3]

IO.inspect(
  Enum.filter([1.2, 2, 5, 8.6], &(is_integer(&1)))
) #=> [2, 5]

# Enum.reduce/3 can be used to transform an enumerable into anything

#  Enum.reduce(
#    enumerable,
#    initial_accumulator_value,
#    fn(element, accumulator) ->
#      ...
#    end
#  )

# sum elements in a list:
IO.inspect(
  Enum.reduce(
    [1, 2, 3],
    0,
    fn(element, sum) -> sum + element end
  )
) #=> 6

# OR
IO.inspect(
 Enum.reduce([1, 2, 4], 0, &(&1 + &2))
) #=> 7

# OR

IO.inspect(
 Enum.reduce([1, 2, 5], 0, &+/2)
) #=> 8

# OR, in this case, use Enum.sum/1

IO.inspect(
  Enum.sum([1, 2, 6])
) #=> 9

# Enum.reduce/3 with multiclause lambda

IO.inspect(
  Enum.reduce(
    [1, "not_a_number", 2, :x, 7],
    0,
    fn                                                        # multiclause lambda
      element, sum when is_number(element) -> sum + element # matches numerical elements
      _, sum -> sum                                           # matches anything else
    end
  )
) #=> 10

# OR rewrite lambda as a distinct function

defmodule NumHelper do
  def sum_nums(enumerable) do
    Enum.reduce(enumerable, 0, &add_num/2)
  end

  defp add_num(num, sum) when is_number(num), do: sum + num
  defp add_num(_, sum), do: sum
end

IO.inspect(NumHelper.sum_nums([1, "not_a_number", 2, :x, 8])) #=> 11
