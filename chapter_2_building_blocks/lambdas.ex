square = fn(x) ->
  x * x
end

# Note the dot operator
IO.puts(square.(5)) #=> 25

print_square = fn(x) ->
  IO.puts(square.(x))
end

list = [2, 3, 4]
Enum.each(list, print_square) #=> 4
                              #=> 9
                              #=> 16

# lambda can be used directly (without temporary variable):
Enum.each(list, fn(x) -> IO.puts(x *x) end) #=> 4
                                            #=> 9
                                            #=> 16

# capture operator simplifies this syntax:
cube = &(IO.puts(&1 * &1 * &1))
cube.(3) #=> 27

Enum.each(list, &(IO.puts(&1 * &1 * &1))) #=> 8
                                          #=> 27
                                          #=> 64

# lambdas can reference any variable outside scope
my_lambda = fn() ->
  Enum.each(list, &IO.puts/1) # list not defined in this scope
end

my_lambda.() #=> 2
             #=> 3
             #=> 4

# Note that rebinding a variable doesn't free it up for garbage collection
# if it is still referecnced by a lambda:
list = [10, 11, 12]
my_lambda.() #=> 2
             #=> 3
             #=> 4

Enum.each(list, &IO.puts/1) #=> 10
                            #=> 11
                            #+> 12
