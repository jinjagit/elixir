IO.inspect(
  for x <- [1, 2, 3] do
    x * x
  end
) #=> [1, 4, 9]

# The above comprehension iterates through each element and runs the do/end
# block. The result is a list that contains all the results returned by the
# do/end block. In this basic form, for is no different than Enum.map/2.

# It’s also possible to perform nested iterations over multiple collections.
# The following example takes advantage of this feature to calculate a small
# multiplication table:

IO. inspect(
  for x <- [1, 2, 3], y <- [1, 2, 3], do: {x, y, x * y}
) #=> [
#=>    {1, 1, 1},
#=>    {1, 2, 2},
#=>    {1, 3, 3},
#=>    {2, 1, 2},
#=>    {2, 2, 4},
#=>    {2, 3, 6},
#=>    {3, 1, 3},
#=>    {3, 2, 6},
#=>    {3, 3, 9}
#=>   ]


# Comprehensions can return anything that is collectable.
# The following snippet makes a map that holds a multiplication table.
# Its keys are tuples of factors {x,y}, and the values contain products.
# Note the into option, which specifies what to collect. In this case,
# it’s an empty map %{} that will be populated with values returned from the
# do block. Notice how you return a {factors, product} tuple from the do block.
# You use this format because map “knows” how to interpret it. The first element
# will be used as a key, and the second one will be used as the corresponding
# value.

multiplication_table =
  for x <- 1..9, y <- 1..9,
      into: %{} do
    {{x, y}, x * y}
  end

IO.inspect(multiplication_table[{7, 6}]) #=> 42
IO.inspect(multiplication_table[{11, 21}]) #=> nil


# Filters can be specified. The following example computes a nonsymmetrical
# multiplication table for numbers x and y, where x is never greater than y:

multiplication_table =
  for x <- 1..9, y <- 1..9,
      x <= y,
      into: %{} do
    {{x, y}, x * y}
  end

IO.inspect(multiplication_table[{5, 7}]) #=> 35
IO.inspect(multiplication_table[{7, 5}]) #=> nil
