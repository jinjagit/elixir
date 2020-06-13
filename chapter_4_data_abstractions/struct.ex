# defining a structure (only one per module):

defmodule Fraction do
  defstruct a: nil, b: nil

  def new(a, b) do
    %Fraction{a: a, b: b} # instantiating a struct
  end

  def decimal(%Fraction{a: a, b: b}), do: a / b

  def decimal2(fraction), do: fraction.a / fraction.b # clearer, but slightly slower

  def add(
  %Fraction{a: a1, b: b1},
  %Fraction{a: a2, b: b2}
  ) do
    new(
    a1 * b2 + a2 * b1,
    b2 * b1
    )
  end

  def mapify(%Fraction{a: a, b: b}), do: %{a: a, b: b} # see final comments in this file
end

one_half = Fraction.new(1, 2) # make a new instance

IO.inspect(one_half) #=> %Fraction{a: 1, b: 2}

IO.puts(Fraction.decimal(one_half)) #=> 0.5
IO.puts(Fraction.decimal2(one_half)) #=> 0.5

result = Fraction.add(Fraction.new(1, 2), Fraction.new(1, 4))
IO.inspect(result) #=> %Fraction{a: 6, b: 8}
IO.puts(Fraction.decimal(result)) #=> 0.75


# By representing fractions with a struct, you can provide the definition of
# your type, listing all fields and their default values. Furthermore, it’s
# possible to distinguish struct instances from any other data type.
# This allows you to place %Fraction{} matches in function arguments, thus
# asserting that you only accept fraction instances.

# However, even though structs are basically maps, not everything that can be
# done with maps can be done with structs. In our fraction example we have not
# specified that it is enumerable (nor how it should be enumerated), therefore
# Enum can't be called on on our Fraction struct.

# Map functions do work on structs:

# IO.inspect(Enum.to_list(one_half)) #=> ** (Protocol.UndefinedError) protocol Enumerable not implemented for %Fraction{a: 1, b: 2} of type Fraction (a struct)

IO.inspect(
  Map.to_list(one_half)
) #=> [__struct__: Fraction, a: 1, b: 2]

# Note, the following returns a map, not a list
IO.inspect(one_half, structs: false) #=> %{__struct__: Fraction, a: 1, b: 2}


# The struct field has an important consequence on pattern matching.
# A struct pattern can’t match a plain map:
#
# iex(5)> %Fraction{} = %{a: 1, b: 2}
# ** (MatchError) no match of right hand side value: %{a: 1, b: 2}
#
# But a plain map pattern can match a struct:
#
# iex(5)> %{a: a, b: b} = %Fraction{a: 1, b: 2}
# %Fraction{a: 1, b: 2}
#
# iex(6)> a
# 1
#
# iex(7)> b
# 2
