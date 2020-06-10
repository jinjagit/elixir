# pattern matching

IO.inspect({x, x, x} = {3, 3, 3}) #=> {3, 3, 3}
# IO.inspect({x, x, x} = {3, 3, 2}) #=> ** (MatchError) no match of right hand side value: {3, 3, 2}
IO.inspect({x, x, _} = {3, 3, 2}) #=> {3, 3, 2}

{name, age} = {"Bob", 35}
IO.puts(name) #=> Bob
IO.puts(age) #=> 35

person = {:person, "Ana", 27}
IO.inspect(person) #=> {:person, "Ana", 27}
{:person, name, age} = person # this binds values to variables
IO.puts(name) #=> Ana

expected_value = 42
# Note that the pin operator, '^', does not bind a value
IO.inspect({^expected_value, _ } = {42, 36}) #=> {42, 36}
# IO.inspect({^expected_value, _ } = {27, 36}) #=> ** (MatchError) no match of right hand side value: {27, 36}

# list matching

[1, second, third] = [1, 2, 3] # first element must be 1
[first, first, first] = [1, 1, 1] # all elements must have same value
[first, second, _] = [1, 2, 3] # 3rd element must exist, but value ignored
[^first, second, _] = # first elelement must have same value as variable 'first'

# inefficient example of finding smallest value in list
[min | _] = Enum.sort([3, 2, 1]) # name 'min' is bound to value of head of sorted list
IO.puts(min) #=> 1

# same idea, using hd function
min = hd(Enum.sort([9, 5, 7]))
IO.puts(min) #=> 5

# map matching

%{name: name, age: age} = %{name: "Jim", age: 66}
IO.puts(name) #=> Jim
IO.puts(age) #=> 66

# left-side pattern does not need to contain all terms on right side
%{age: age} = %{name: "Sarah", age: 44}
IO.puts(age) #=> 44

# ... but will fail if pattern contains key not in matched term
# left-side pattern does not need to contain all terms on right side
# %{age: age, height: 165} = %{name: "Sarah", age: 44} #=> no match of right hand side value: %{age: 44, name: "Sarah"}

# binary matching

# this format is good for (many / most) arbitrarily sized binaries
binary = <<1, 2, 3>>
<<b1, remainder :: binary>> = binary
IO.inspect(remainder) #=> <<2, 3>>

# expecting 4-bit value(s)
<<a :: 4, b :: 4>> = <<155>>
IO.puts(a) #=> 9 (since 1001 is first 4 bits of 155 as 8-bit number)

# binary string matching

phrase = "My name is Simon"
"My name is " <> name = phrase
IO.puts(name) #=> Simon

# general points

a = b = 1 + 3
IO.puts(a) #=> 4
IO.puts(b) #=> 4


date_time = {_, {hour, _, _}} = :calendar.local_time
IO.inspect(date_time) #=> {{2020, 6, 10}, {17, 49, 30}}
IO.puts(hour) #=> 17

{_, {hour, _, _}} = date_time = :calendar.local_time
IO.inspect(date_time) #=> {{2020, 6, 10}, {17, 49, 30}}
IO.puts(hour) #=> 17

# function argument pattern matching
# multiclause function

defmodule Geometry do
  def area({:rectangle, a, b}), do: a* b
  def area({:square, a}), do: a * a
  def area({:circle, r}), do: r * r * 3.14159
  def area(unknown), do: {:error, {:unknown_shape, unknown}}
end

IO.puts(Geometry.area({:rectangle, 4, 5})) #=> 20
IO.puts(Geometry.area({:square, 4})) #=> 16
IO.puts(Geometry.area({:circle, 4})) #=> 50.26544
IO.inspect(Geometry.area({:triangle, 3, 4, 5})) #=> 50.26544


geom = &Geometry.area/1 # captures the multicaluse function

IO.puts(geom.({:circle, 4}))#=> 50.26544

# guards

defmodule TestNum do
  def test(x) when is_number(x) and x < 0 do
    :negative
  end

  def test(0), do: :zero

  def test(x) when is_number(x) and x > 0 do
    :positive
  end
end

IO.puts(TestNum.test(-0.5)) #=> negative
# IO.puts(TestNum.test(:not_a_number)) #=> ** (FunctionClauseError) no function clause matching in TestNum.test/1

# multiclause lambdas

test_num = fn
  x when is_number(x) and x < 0 ->
    :negative
  0 -> :zero
  x when is_number(x) and x > 0 ->
    :positive
end

IO.puts(test_num.(2)) #=> positive
